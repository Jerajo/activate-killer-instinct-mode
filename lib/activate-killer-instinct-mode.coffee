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
    @active = true
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-killer-instinct-mode:toggle": => @toggle()

    #require('atom-package-deps').install('activate-killer-instinct-mode')

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateKillerInstinctMode', @exclamationControler)

  deactivate: ->
    console.log "Estoy inactivo. XP"
    @active = false
    @exclamationControler.disable()

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    console.log "Estoy activo. XD"
    @active = true
    @exclamationControler.enable()

  disable: ->
    console.log "Estoy inactivo. XP"
    @active = false
    @exclamationControler.disable()
