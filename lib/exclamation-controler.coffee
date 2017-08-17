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
    @active = true
    @api = api
    @combo = @api.getCombo()
    @setup()

  disable: ->
    console.log "Se invoca: (destroid)"
    @configObserver.desable()
    @exclamation.disable()
    @active = false

  setup: ->
    console.log "Se invoca: (setup)"
    @configObserver.setup()
    @exclamation.enable @configObserver.path

  onChangePane: (editor, editorElement) ->
    console.log "Se invoca: (onChangePane)"
    if @active and @configObserver.style is "killerInstinct" and @configObserver.multiplier
      @setConfig "activate-power-mode.comboMode.multiplier", false

  onInput: (cursor, screenPosition, input, data) ->
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
      console.log "Se invoca: (onInput)"

  onComboLevelChange: (newLvl, oldLvl) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.onNextLevel != null
      @exclamation.play(@configObserver.onNextLevel, @configObserver.style)
      console.log "Se invoca: (onComboLevelChange)"

  onComboEndStreak: ->
    if @active and @currentStreak >= 3 and @configObserver.display is "endStreak"
      if @configObserver.types != "onlyText"
        @exclamation.play(@configObserver.path, @configObserver.style, @currentStreak)
      @currentStreak = 0
      console.log "Se invoca: (onComboEndStreak)"

  onComboExclamation: (text) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.display is "duringStreak"
      @exclamation.play(@configObserver.path, @configObserver.style, 0) if @configObserver.types != "onlyText"
      text = "Holla Jesse"
      console.log "Se invoca: (onComboExclamation)"

  onComboMaxStreak: (maxStreak) ->
    if @active and @configObserver.types != "onlyText" and @configObserver.onNewMax != null
      @exclamation.play(@configObserver.onNewMax, @configObserver.style)
      console.log "Se invoca: (onComboMaxStreak)"

  getConfig: (config) ->
    atom.config.get "activate-killer-instinct-mode.#{config}"

  setConfig: (config, value) ->
    atom.config.set config, value
