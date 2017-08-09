exclamation = require "./play-exclamation"

module.exports =

  active: false
  api: null
  exclamation: exclamation
  isCombomode: false

  enable: (api) ->
    @active = true
    @api = api
    @setup()

  disable: ->
    console.log "Se invoca: (destroid)"
    @exclamation.disable()
    @active = false
    @api = null

  setup: ->
    console.log "Se invoca: (setup)"

  onNewCursor: (cursor) ->
    console.log "Se invoca: (onNewCursor)"

  onInput: (cursor, screenPosition, input, data) ->
    console.log "Se invoca: (onInput)"

  onComboStartStreak: ->
    console.log "Se invoca: (onComboStartStreak)"

  onComboLevelChange: (newLvl, oldLvl) ->
    console.log "Se invoca: (onComboLevelChange)"

  onComboEndStreak: ->
    console.log "Se invoca: (onComboEndStreak)"

  onComboExclamation: (text) ->
    console.log "Se invoca: (onComboExclamation)"

  onComboMaxStreak: (maxStreak) ->
    console.log "Se invoca: (onComboMaxStreak)"

  getConfig: (config) ->
    atom.config.get "activate-background-music.playBackgroundMusic.#{config}"

  setConfig: (config) ->
    atom.config.set "activate-background-music.actions.#{config}"
