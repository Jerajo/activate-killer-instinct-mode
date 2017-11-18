playExclamation = require './play-exclamation'

module.exports =

  title: "Combo Breaker Flow"
  description: "Custom Flow for Killer Instinct Exclamations"

  handle: (input, switcher, comboLvl) ->
    if comboLvl == 0
      switcher.offAll()
      switcher.on('comboMode')

    if input.hasDeleted() and atom.config.get "activate-killer-instinct-mode.comboMode.breakCombo"
      switcher.on('comboMode', {'reset': yes})
