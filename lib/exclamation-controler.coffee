exclamation = require "./play-exclamation"
configObserver = require './config-observers'

module.exports =

  active: false
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
    @active = false

  setup: ->
    @active = true
    console.log @configObserver
    @configObserver.setup()
    @exclamation.enable @configObserver.path

  onChangePane: (editor, editorElement) ->
    if @active and @configObserver.style is "killerInstinct" and @configObserver.multiplier
      @setConfig "activate-power-mode.comboMode.multiplier", false

  onInput: (cursor, screenPosition, input, data) ->
    console.log "OmInput se Invoca"
    if @active
      @currentStreak = @combo.getCurrentStreak()
      play = false
      mod = @currentStreak % @configObserver.lapse
      if @configObserver.multiplier
        currentLevel = @combo.getLevel()
        n = currentLevel + 1
        play = true if (@currentStreak - n < @currentStreak - mod < @currentStreak)
      if mod is 0 or play
       exclamation = @exclamation.play(@configObserver.superExclamation, @configObserver.style)
       @combo.exclame(word = exclamation, type = null)

  onComboLevelChange: (newLvl, oldLvl) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.onNextLevel != null
      @exclamation.play(@configObserver.onNextLevel, @configObserver.style)

  onComboEndStreak: ->
    if @active and @currentStreak >= 3 and @configObserver.display is "endStreak"
      if @configObserver.types != "onlyText"
        @exclamation.play(@configObserver.path, @configObserver.style, @currentStreak)
      @currentStreak = 0

  onComboExclamation: (text) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.display is "duringStreak"
      @exclamation.play(@configObserver.path, @configObserver.style, 0) if @configObserver.types != "onlyText"
      text = "Holla Jesse"

  onComboMaxStreak: (maxStreak) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.onNewMax != null
      @exclamation.play(@configObserver.onNewMax, @configObserver.style)

  setConfig: (config, value) ->
    atom.config.set config, value
