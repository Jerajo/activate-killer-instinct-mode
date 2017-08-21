{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
killerInstinct = require "./killer-instinct"

module.exports = activateKillerInstinctMode =

  active: false
  config: configSchema
  subscriptions: null
  killerInstinct: killerInstinct

  activate: (state) ->
    @active = @setConfig(true) if !@isActive()
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-killer-instinct-mode:toggle": => @toggle()

    require('atom-package-deps').install('activate-killer-instinct-mode')

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('activateKillerInstinctMode', @killerInstinct)

  deactivate: ->
    @subscriptions?.dispose()
    @active = @setConfig(false) if @isActive()

  toggle: ->
    if @isActive() then @disable() else @enable()

  enable: ->
    @active = @setConfig(true)

  disable: ->
    @active = @setConfig(false)

  isActive: ->
    atom.config.get "activate-power-mode.plugins.activateKillerInstinctMode"

  setConfig: (value) ->
    atom.config.set "activate-power-mode.plugins.activateKillerInstinctMode", value
    value
