module.exports =
  style: ""
  breakCombo: false
  volume: 0
  type: ""
  display: ""
  path: ""
  onDelete: ""
  onNextLevel: ""
  onNewMax: ""
  superExclamation: ""
  mute: true
  setup: false

  setup: ->
    @typeObserver?.dispose()
    @typeObserver = atom.config.observe 'activate-killer-instinct-mode.custom.type', (value) =>
      @type = value
      if @setup and @style is "killerInstinct" and @type != "both"
        @setConfig("comboMode.style", "custom")

    @displayObserver?.dispose()
    @displayObserver = atom.config.observe 'activate-killer-instinct-mode.custom.display', (value) =>
      @display = value
      if @setup and @style is "killerInstinct" and @display is "duringStreak"
        @setConfig("comboMode.style", "custom")

    @pathObserver?.dispose()
    @pathObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.path', (value) =>
      @path = value
      if @setup and @style is "killerInstinct" and @path != "../sounds/"
        @setConfig("comboMode.style", "custom")

    @styleObserver?.dispose()
    @styleObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.style', (value) =>
      @style = value
      if @setup and @style is "killerInstinct"
        @setConfig("comboMode.breakCombo", true) if not @breakCombo
        @setConfig("custom.type", "both") if @type != "both"
        @setConfig("custom.display", "endStreak") if @type != "endStreak"
        @setConfig("custom.audioFiles.path", "../sounds/") if @path != "../sounds/"
        if @onDelete != "Combo Breaker.wav"
          @setConfig("custom.audioFiles.onDelete", "Combo Breaker.wav")
        if @onNextLevel != "Level Up.wav"
          @setConfig("custom.audioFiles.onNextLevel", "Level Up.wav")
        if @onNewMax != "Maxximun Power.wav"
          @setConfig("custom.audioFiles.onNewMax", "Maxximun Power.wav")
        if @superExclamation != "Yes oh my God.wav"
          @setConfig("superExclamation.path", "Yes oh my God.wav")
        if atom.packages.isPackageActive("activate-background-music") and not @mute
          @setConfig("superExclamation.mute", true)

    @volumeObserver?.dispose()
    @volumeObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.volume', (value) =>
      @volume = (value * 0.01)

    @onDeleteObserver?.dispose()
    @onDeleteObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onDelete', (value) =>
      @onDelete = value

    @onNextLevelObserver?.dispose()
    @onNextLevelObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onNextLevel', (value) =>
      @onNextLevel = value

    @onNewMaxObserver?.dispose()
    @onNewMaxObserver = atom.config.observe 'activate-killer-instinct-mode.custom.audioFiles.onNewMax', (value) =>
      @onNewMax = value

    @superExclamationObserver?.dispose()
    @superExclamationObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.path', (value) =>
      @superExclamation = value

    @muteObserver?.dispose()
    @muteObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.mute', (value) =>
      @mute = value

    @setup = true

  destroy: ->
    @setup = false
    @superExclamationObserver?.dispose()
    @onNextLevelObserver?.dispose()
    @onDeleteObserver?.dispose()
    @onNewMaxObserver?.dispose()
    @displayObserver?.dispose()
    @volumeObserver?.dispose()
    @styleObserver?.dispose()
    @typeObserver?.dispose()
    @pathObserver?.dispose()
    @muteObserver?.dispose()

  setConfig: (config, value) ->
    atom.config.set "activate-killer-instinct-mode.#{config}", value
