exclamation = require "./play-exclamation"
configObserver = require './config-observers'
debounce = require "lodash.debounce"

module.exports =

  title: 'Activate Killer Instinct Mode'
  description: 'A plugin for activate power mode that plays killer instinct exclamations.'
  name: "activate-killer-instinct-mode"
  type: "package"
  api: null
  combo: null
  exclamation: exclamation
  configObserver: configObserver
  isCombomode: false
  currentStreak: 0
  streakEnds: false

  enable: (api) ->
    @api = api
    @combo = @api.getCombo()
    @setup()

  disable: ->
    @debounceEndStreakObserve?.cancel()
    @debounceEndStreakObserve = null
    @configObserver.disable()
    @exclamation.disable()

  setup: ->
    @configObserver.setup()
    @exclamation.enable @configObserver.path
    @debounceEndStreakObserve?.cancel()
    @debounceEndStreakObserve = debounce @checkStreak.bind(this), @configObserver.timeLapse

  checkStreak: ->
    @streakEnds = true

  onChangePane: (editor, editorElement) ->
    if atom.packages.isPackageDisabled("activate-background-music") and @configObserver.mute
      @configObserver.mute = false

    if @configObserver.style is "killerInstinct" and @configObserver.multiplier
      @setConfig "activate-power-mode.comboMode.multiplier", false

  onInput: (cursor, screenPosition, input, data) ->
    @currentStreak = @combo.getCurrentStreak()
    @debounceEndStreakObserve() if @currentStreak > 0
    if input.hasDeleted() and @configObserver.onDelete != null and @configObserver.breakCombo
      return @combo.exclame("Combo Breaker!") if @configObserver.types is "onlyText"
      eclamation = @comboBreaker()
      @combo.exclame(eclamation) if @configObserver.types != "onlyAudio"
      return
    if @configObserver.superExclamation != null and @checkExclamation(@configObserver.SELapse)
      return @combo.exclame("Yes oh my God!") if @configObserver.types is "onlyText"
      eclamation = @superExclamation()
      @combo.exclame(eclamation) if @configObserver.types != "onlyAudio"
      return
    if @configObserver.display is "duringStreak" and @checkExclamation(@configObserver.ELapse)
      return if @configObserver.types != "onlyAudio"
      eclamation = @exclamationDuringStreak()
      @combo.exclame(eclamation) if @configObserver.types != "onlyAudio"


  exclamationDuringStreak: ->
    @exclamation.play(@configObserver.path, @configObserver.types)

  superExclamation: ->
    @exclamation.muteTogle(true) if @configObserver.mute
    @exclamation.play(@configObserver.superExclamation, @configObserver.types)

  comboBreaker: ->
    @combo.resetCounter()
    @exclamation.play(@configObserver.onDelete, @configObserver.types)

  checkExclamation: (lapse) ->
    return false if @currentStreak is 0
    return true if (mod = @currentStreak % lapse) is 0
    return false if !@configObserver.multiplier
    currentLevel = @combo.getLevel()
    n = currentLevel + 1
    return if (@currentStreak - n < @currentStreak - mod < @currentStreak) then true else false

  onComboLevelChange: (newLvl, oldLvl) ->
    if @configObserver.onNextLevel != null
      return @combo.exclame("Level Up!") if @configObserver.types is "onlyText"
      exclamation = @exclamation.play(@configObserver.onNextLevel, @configObserver.types)
      @combo.exclame(exclamation) if @configObserver.types != "onlyAudio"

  onComboEndStreak: ->
    if !@streakEnds
      return @debounceEndStreakObserve?.cancel()
    @streakEnds = false
    if @currentStreak >= 3 and @configObserver.display is "endStreak"
      exclamation = @exclamation.play(@configObserver.path, @configObserver.types, @currentStreak)
      @combo.exclame(exclamation) if @configObserver.types != "onlyAudio"

  onComboMaxStreak: (maxStreak) ->
    if @configObserver.types != "onlyText" and @configObserver.onNewMax != null
      @exclamation.play(@configObserver.onNewMax, @configObserver.types)

  setConfig: (config, value) ->
    atom.config.set config, value
