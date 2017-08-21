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
    if @configObserver.style is "killerInstinct" and @configObserver.multiplier
      @setConfig "activate-power-mode.comboMode.multiplier", false

  onInput: (cursor, screenPosition, input, data) ->
    @currentStreak = @combo.getCurrentStreak()
    play = false
    mod = @currentStreak % @configObserver.lapse
    if @configObserver.multiplier
      currentLevel = @combo.getLevel()
      n = currentLevel + 1
      play = true if (@currentStreak - n < @currentStreak - mod < @currentStreak)
    if mod is 0 or play
      #atom.commands.dispatch "atom-workspace", "activate-background-music:play/pasue"
      exclamation = @exclamation.play(@configObserver.superExclamation, @configObserver.style)
      @combo.exclame(word = exclamation, type = null)

  onComboLevelChange: (newLvl, oldLvl) ->
    if @configObserver.types != "onlyText" and @configObserver.onNextLevel != null
      exclamation = @exclamation.play(@configObserver.onNextLevel, @configObserver.style)
      @combo.exclame(word = exclamation, type = null)

  onComboEndStreak: ->
    if @currentStreak >= 3 and @configObserver.display is "endStreak"
      if @configObserver.types != "onlyText"
        exclamation = @exclamation.play(@configObserver.path, @configObserver.style, @currentStreak)
        @combo.exclame(word = exclamation, type = null)
      @currentStreak = 0

  onComboExclamation: (text) ->
    if @configObserver.types != "onlyText" and @configObserver.display is "duringStreak"
      exclamation = @exclamation.play(@configObserver.path, @configObserver.style, 0) if @configObserver.types != "onlyText"
      @combo.exclame(word = exclamation, type = null)

  onComboMaxStreak: (maxStreak) ->
    if @configObserver.types != "onlyText" and @configObserver.onNewMax != null
      @exclamation.play(@configObserver.onNewMax, @configObserver.style)

  setConfig: (config, value) ->
    atom.config.set config, value
