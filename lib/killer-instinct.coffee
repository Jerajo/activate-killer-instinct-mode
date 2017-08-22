exclamation = require "./play-exclamation"
configObserver = require './config-observers'

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

  enable: (api) ->
    @api = api
    @combo = @api.getCombo()
    @setup()

  disable: ->
    @configObserver.disable()
    @exclamation.disable()

  setup: ->
    @configObserver.setup()
    @exclamation.enable @configObserver.path

  onChangePane: (editor, editorElement) ->
    if atom.packages.isPackageDisabled("activate-background-music") and @configObserver.mute
      @configObserver.mute = false

    if @configObserver.style is "killerInstinct" and @configObserver.multiplier
      @setConfig "activate-power-mode.comboMode.multiplier", false

  onInput: (cursor, screenPosition, input, data) ->
    console.log "onInput called"
    @currentStreak = @combo.getCurrentStreak()
    if @configObserver.types != "onlyText"
      if input.hasDeleted() and @configObserver.onDelete != null and @configObserver.breakCombo
        return @combo.exclame(@comboBreaker())
      if @configObserver.superExclamation != null and @checkExclamation(@configObserver.SELapse)
        return @combo.exclame(@superExclamation())
      if @configObserver.display is "duringStreak" and @checkExclamation(@configObserver.ELapse)
        return @combo.exclame(@exclamationDuringStreak())

  exclamationDuringStreak: ->
    console.log "exclamationDuringStreak called"
    @exclamation.play(@configObserver.path, @configObserver.style)

  superExclamation: ->
    console.log "superExclamation called"
    @exclamation.muteTogle(true) if @configObserver.mute
    @exclamation.play(@configObserver.superExclamation, @configObserver.style)

  comboBreaker: ->
    console.log "comboBreaker called"
    @combo.resetCounter()
    @exclamation.play(@configObserver.onDelete, @configObserver.style)

  checkExclamation: (lapse) ->
    return false if @currentStreak is 0
    return true if (mod = @currentStreak % lapse) is 0
    return false if !@configObserver.multiplier
    currentLevel = @combo.getLevel()
    n = currentLevel + 1
    return if (@currentStreak - n < @currentStreak - mod < @currentStreak) then true else false

  onComboLevelChange: (newLvl, oldLvl) ->
    if @configObserver.types != "onlyText" and @configObserver.onNextLevel != null
      exclamation = @exclamation.play(@configObserver.onNextLevel, @configObserver.style)
      @combo.exclame(exclamation) if @configObserver.types != "onlyAudio"

  onComboEndStreak: ->
    if @currentStreak >= 3 and @configObserver.display is "endStreak"
      if @configObserver.types != "onlyText"
        exclamation = @exclamation.play(@configObserver.path, @configObserver.style)
        @combo.exclame(exclamation) if @configObserver.types != "onlyAudio"

  onComboMaxStreak: (maxStreak) ->
    if @configObserver.types != "onlyText" and @configObserver.onNewMax != null
      @exclamation.play(@configObserver.onNewMax, @configObserver.style)

  setConfig: (config, value) ->
    atom.config.set config, value
