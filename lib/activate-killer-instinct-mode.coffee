{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
exclamationControler = require "./exclamation-controler"

module.exports = activateKillerInstinctMode =

  config: configSchema
  subscriptions: null
  active: false
  exclamationControler: exclamationControler

  activate: (state) ->
    console.log "Hola soy tu paquete Activate Killer Instinct Mode. XD"
    active = true
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-background-music:toggle": => @toggle()

    #require('atom-package-deps').install('activate-background-music')

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateKillerInstinctMode', @exclamationControler)

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    console.log "Estoy activo. XD"
    @active = true
    @exclamationControler.enable()
    @playIntroAudio.play() if @getConfig "playIntroAudio.enabled"

  disable: ->
    console.log "Estoy inactivo. XP"
    @active = false
    @exclamationControler.disable()
