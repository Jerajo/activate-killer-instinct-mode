{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
killerInstinct = require "./killer-instinct"
comboBreaker = require "./combo-breaker"

module.exports = activateKillerInstinctMode =

  active: off
  config: configSchema
  subscriptions: null
  killerInstinct: killerInstinct

  activate: (state) ->
    @active = @setConfig(on) unless @isActive()
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "activate-killer-instinct-mode:toggle": => @toggle()

    require('atom-package-deps').install('activate-killer-instinct-mode')

  consumeActivatePowerModeServiceV1: (service) ->
    service.registerPlugin('killerInstinctExclamations', @killerInstinct)
    service.registerFlow('comboBreaker', comboBreaker);

  deactivate: ->
    @subscriptions?.dispose()
    @active = @setConfig(off) if @isActive()

  toggle: ->
    if @isActive() then @disable() else @enable()

  enable: ->
    @active = @setConfig(on)

  disable: ->
    @active = @setConfig(off)

  isActive: ->
    atom.config.get "activate-power-mode.plugins.killerInstinctExclamations"

  setConfig: (value) ->
    atom.config.set "activate-power-mode.plugins.killerInstinctExclamations", value
    value
