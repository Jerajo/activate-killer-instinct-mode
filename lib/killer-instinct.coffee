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
  observer: configObserver
  currentStreak: 0
  streakEnds: no

  enable: (api) ->
    @api = api
    @combo = @api.getCombo()
    @setup()

  disable: ->
    @debounceEndStreakObserve?.cancel()
    @debounceEndStreakObserve = null
    @observer.disable()
    @exclamation.disable()

  setup: ->
    @observer.setup()
    @exclamation.enable @observer.conf['path']
    @debounceEndStreakObserve?.cancel()
    @debounceEndStreakObserve = debounce @checkStreak.bind(this), @observer.conf['timeLapse']

  checkStreak: ->
    @streakEnds = yes

  onChangePane: (editor, editorElement) ->
    if atom.packages.isPackageDisabled("activate-background-music") and @observer.conf['mute']
      @observer.conf['mute'] = off

    if @observer.conf['style'] is "killerInstinct" and @observer.conf['multiplier']
      @setConfig "activate-power-mode.comboMode.multiplier", off

  onInput: (cursor, screenPosition, input, data) ->
    @currentStreak = @combo.getCurrentStreak()
    @debounceEndStreakObserve() if @currentStreak > 0

    if input.hasDeleted() and @observer.conf['onDelete'] isnt null and @observer.conf['breakCombo']
      return @combo.exclame("Combo Breaker!") if @observer.conf['types'] is "onlyText"
      eclamation = @comboBreaker()
      @combo.exclame(eclamation) if @observer.conf['types'] isnt "onlyAudio"
      return

    if @observer.conf['superExclamation'] isnt null and @checkExclamation(@observer.conf['SELapse'])
      return @combo.exclame("Yes oh my God!") if @observer.conf['types'] is "onlyText"
      eclamation = @superExclamation()
      @combo.exclame(eclamation) if @observer.conf['types'] isnt "onlyAudio"
      return

    if @observer.conf['display'] is "duringStreak" and @checkExclamation(@observer.conf['ELapse'])
      eclamation = @exclamationDuringStreak()
      @combo.exclame(eclamation) if @observer.conf['types'] isnt "onlyAudio"


  exclamationDuringStreak: ->
    @exclamation.play(@observer.conf['path'], @observer.conf)

  superExclamation: ->
    @exclamation.muteTogle(yes) if @observer.conf['mute']
    @exclamation.play(@observer.conf['superExclamation'], @observer.conf)

  comboBreaker: ->
    @combo.resetCounter()
    @exclamation.play(@observer.conf['onDelete'], @observer.conf)

  checkExclamation: (lapse) ->
    return false if @currentStreak is 0 or lapse is 0
    return true if (mod = @currentStreak % lapse) is 0
    return false unless @observer.conf['multiplier']
    currentLevel = @combo.getLevel()
    n = currentLevel + 1
    return if (@currentStreak - n < @currentStreak - mod < @currentStreak) then true else false

  onComboLevelChange: (newLvl, oldLvl) ->
    if @observer.conf['onNextLevel'] isnt null
      return @combo.exclame("Level Up!") if @observer.conf['types'] is "onlyText"
      exclamation = @exclamation.play(@observer.conf['onNextLevel'], @observer.conf)
      @combo.exclame(exclamation) if @observer.conf['types'] isnt "onlyAudio"

  onComboEndStreak: ->
    unless @streakEnds
      return @debounceEndStreakObserve?.cancel()
    @streakEnds = no
    if @currentStreak >= 3 and @observer.conf['display'] is "endStreak"
      exclamation = @exclamation.play(@observer.conf['path'], @observer.conf, @currentStreak)
      @combo.exclame(exclamation) if @observer.conf['types'] isnt "onlyAudio"

  onComboMaxStreak: (maxStreak) ->
    if @observer.conf['types'] isnt "onlyText" and @observer.conf['onNewMax'] isnt null
      @exclamation.play(@observer.conf['onNewMax'], @observer.conf)

  setConfig: (config, value) ->
    atom.config.set config, value
