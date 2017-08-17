path = require 'path'

module.exports =
  style: ""
  breakCombo: false
  volume: 0
  types: ""
  display: ""
  path: ""
  onDelete: ""
  onNextLevel: ""
  onNewMax: ""
  superExclamation: ""
  lapse: 0
  multiplier: ""
  mute: true
  setup: false

  setup: ->
    @typesObserver?.dispose()
    @typesObserver = atom.config.observe 'activate-killer-instinct-mode.custom.types', (value) =>
      @types = value
      if @setup and @style is "killerInstinct" and @types != "both"
        @setConfig("comboMode.style", "custom")

    @displayObserver?.dispose()
    @displayObserver = atom.config.observe 'activate-killer-instinct-mode.custom.display', (value) =>
      @display = value
      if @setup and @style is "killerInstinct" and @display is "duringStreak"
        @setConfig("comboMode.style", "custom")

    @pathObserver?.dispose()
    @pathObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.path', (value) =>
      if value is "../sounds/"
        @path = path.join(__dirname, value)
      else @path = value
      if @setup and @style is "killerInstinct" and value != "../sounds/"
        @setConfig("comboMode.style", "custom")

    @styleObserver?.dispose()
    @styleObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.style', (value) =>
      @style = value
      if @setup and @style is "killerInstinct"
        @setConfig("comboMode.breakCombo", true) if not @breakCombo
        @setConfig("custom.types", "both") if @types != "both"
        @setConfig("custom.display", "endStreak") if @display != "endStreak"
        @setConfig("custom.audioFiles.path", "../sounds/") if @path != "../sounds/"
        if @onDelete != "Combo Breaker.wav"
          @setConfig("custom.audioFiles.onDelete", "Combo Breaker.wav")
        if @onNextLevel != "Level Up.wav"
          @setConfig("custom.audioFiles.onNextLevel", "Level Up.wav")
        if @onNewMax != "Maximum Combo.wav"
          @setConfig("custom.audioFiles.onNewMax", "Maximum Combo.wav")
        if @superExclamation != "Yes oh my God.wav"
          @setConfig("superExclamation.path", "Yes oh my God.wav")
        if atom.packages.isPackageActive("activate-background-music") and not @mute
          @setConfig("superExclamation.mute", true)

    @multiplierObserver?.dispose()
    @multiplierObserver = atom.config.observe "activate-power-mode.comboMode.multiplier", (value) =>
      @multiplier = value

    @volumeObserver?.dispose()
    @volumeObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.volume', (value) =>
      @volume = (value * 0.01)

    @onDeleteObserver?.dispose()
    @onDeleteObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onDelete', (value) =>
      if @path is "../sounds/"
        @onDelete = path.join(__dirname, value)
      else @onDelete = value

    @onNextLevelObserver?.dispose()
    @onNextLevelObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onNextLevel', (value) =>
      if @path is "../sounds/"
        @onNextLevel = path.join(__dirname, value)
      else @onNextLevel = value

    @onNewMaxObserver?.dispose()
    @onNewMaxObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onNewMax', (value) =>
      if @path is "../sounds/"
        @onNewMax = path.join(__dirname, value)
      else @onNewMax = value

    @superExclamationObserver?.dispose()
    @superExclamationObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.path', (value) =>
      if @path is "../sounds/"
        @superExclamation = path.join(__dirname, value)
      else @superExclamation = value

    @lapseObserver?.dispose()
    @lapseObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.lapse', (value) =>
      @lapse = value

    @muteObserver?.dispose()
    @muteObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.mute', (value) =>
      @mute = value

    @setup = true

  desable: ->
    @setup = false
    @superExclamationObserver?.dispose()
    @onNextLevelObserver?.dispose()
    @multiplierObserver?.dispose()
    @onDeleteObserver?.dispose()
    @onNewMaxObserver?.dispose()
    @displayObserver?.dispose()
    @volumeObserver?.dispose()
    @styleObserver?.dispose()
    @typesObserver?.dispose()
    @lapseObserver?.dispose()
    @pathObserver?.dispose()    
    @muteObserver?.dispose()

  setConfig: (config, value) ->
    atom.config.set "activate-killer-instinct-mode.#{config}", value
