{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
exclamationControler = require "./exclamation-controler"

module.exports = activateKillerInstinctMode =

  active: false
  config: configSchema
  subscriptions: null
  exclamationControler: exclamationControler

  activate: (state) ->
    @active = @isActive()
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-killer-instinct-mode:toggle": => @toggle()

    require('atom-package-deps').install('activate-killer-instinct-mode')

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateKillerInstinctMode', @exclamationControler)

  deactivate: ->
    @subscriptions?.dispose()
    @active = false;

  toggle: ->
    if @isActive() then @disable() else @enable()

  enable: ->
    console.log "Estoy activo. XD"
    @active = @setConfig(true)

  disable: ->
    console.log "Estoy inactivo. XP"
    @active = @setConfig(false)

  isActive: ->
    atom.config.get "activate-power-mode.plugins.activateKillerInstinctMode"

  setConfig: (value) ->
    atom.config.set "activate-power-mode.plugins.activateKillerInstinctMode", value
    value
