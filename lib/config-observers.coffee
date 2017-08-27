path = require 'path'
fs = require 'fs'

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
  ELapse: 0
  SELapse: 0
  multiplier: ""
  mute: true
  isSetup: false
  exclamations: null
  timeLapse: 0

  setup: ->
    @activationThresholdObserver?.dispose()
    @activationThresholdObserver = atom.config.observe 'activate-power-mode.comboMode.activationThreshold', (lapse) =>
      if lapse[0] != "1"
        lapse.unshift("1")
        atom.config.set "activate-power-mode.comboMode.activationThreshold", lapse

    @typesObserver?.dispose()
    @typesObserver = atom.config.observe 'activate-killer-instinct-mode.customSettings.types', (value) =>
      @types = value
      if @isSetup and @style is "killerInstinct" and @types != "both"
        @setConfig("comboMode.style", "custom")

    @displayObserver?.dispose()
    @displayObserver = atom.config.observe 'activate-killer-instinct-mode.customSettings.display', (value) =>
      @display = value
      if @isSetup and @style is "killerInstinct" and @display is "duringStreak"
        @setConfig("comboMode.style", "custom")

    @pathObserver?.dispose()
    @pathObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.path', (value) =>
      if value is "../sounds/"
        @path = path.join(__dirname, value)
      else @path = value
      if @isSetup and @style is "killerInstinct" and value != "../sounds/"
        @setConfig("comboMode.style", "custom")

      @refreshFiles()
      if @exclamations is null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("customExclamations.path","../sounds/")

    @styleObserver?.dispose()
    @styleObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.style', (value) =>
      @style = value
      if @isSetup and @style is "killerInstinct"
        @setConfig("comboMode.breakCombo", true) if not @breakCombo
        @setConfig("customSettings.types", "both") if @types != "both"
        @setConfig("customSettings.display", "endStreak") if @display != "endStreak"
        @setConfig("customExclamations.path", "../sounds/") if @path != "../sounds/"
        if @onDelete != "Combo Breaker.wav"
          @setConfig("customExclamations.onDelete", "Combo Breaker.wav")
        if @onNextLevel != "Level Up.wav"
          @setConfig("customExclamations.onNextLevel", "Level Up.wav")
        if @onNewMax != "Maximum Combo.wav"
          @setConfig("customExclamations.onNewMax", "Maximum Combo.wav")
        if @superExclamation != "Yes oh my God.wav"
          @setConfig("superExclamation.path", "Yes oh my God.wav")
        if atom.packages.isPackageActive("activate-background-music") and not @mute
          @setConfig("superExclamation.mute", true)

    @breakComboObserver?.dispose()
    @breakComboObserver = atom.config.observe "activate-killer-instinct-mode.comboMode.breakCombo", (value) =>
      @breakCombo = value
      if @breakCombo
        atom.config.set "activate-power-mode.flow", "comboBreaker"
      else
        atom.config.set "activate-power-mode.flow", "default"

    @flowObserver?.dispose()
    @flowObserver = atom.config.observe "activate-power-mode.flow", (value) =>
      if value is "comboBreaker"
        atom.config.set "activate-killer-instinct-mode.comboMode.breakCombo", true
      else
        atom.config.set "activate-killer-instinct-mode.comboMode.breakCombo", false

    @multiplierObserver?.dispose()
    @multiplierObserver = atom.config.observe "activate-power-mode.comboMode.multiplier", (value) =>
      @multiplier = value

    @volumeObserver?.dispose()
    @volumeObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.volume', (value) =>
      @volume = (value * 0.01)

    @onDeleteObserver?.dispose()
    @onDeleteObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onDelete', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then true else false
        break if exits
      console.error "File didn't found on: " + @path if not exits and value != ""
      @onDelete = if value != "" and exits then @path + value else null

    @onNextLevelObserver?.dispose()
    @onNextLevelObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onNextLevel', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then true else false
        break if exits
      console.error "File didn't found on: " + @path if not exits and value != ""
      @onNextLevel = if value != "" and exits then @path + value else null

    @onNewMaxObserver?.dispose()
    @onNewMaxObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onNewMax', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then true else false
        break if exits
      console.error "File didn't found on: " + @path if not exits and value != ""
      @onNewMax = if value != "" and exits then @path + value else null

    @superExclamationObserver?.dispose()
    @superExclamationObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.path', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then true else false
        break if exits
      console.error "File didn't found on: " + @path if not exits and value != ""
      @superExclamation = if value != "" and exits then @path + value else null

    @ElapseObserver?.dispose()
    @ElapseObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.lapse', (value) =>
      @ELapse = value

    @SElapseObserver?.dispose()
    @SElapseObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.lapse', (value) =>
      @SELapse = value

    @exclamationObserver?.dispose()
    @exclamationObserver = atom.config.observe 'activate-power-mode.comboMode.exclamationEvery', (value) =>
      if value != 0
        atom.config.set "activate-power-mode.comboMode.exclamationEvery", 0

    @muteObserver?.dispose()
    @muteObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.mute', (value) =>
      isIstalled = false
      packages = atom.packages.getAvailablePackageNames()

      for code, name of packages
        if name is "activate-background-music"
          isIstalled = true
          break
        else isIstalled = false

      if (!isIstalled or atom.packages.isPackageDisabled("activate-background-music")) and value
        return @setConfig("superExclamation.mute", false)
      @mute = value

    @timeLapseObserver?.dispose()
    @timeLapseObserver = atom.config.observe "activate-power-mode.comboMode.streakTimeout", (value) =>
      @timeLapse = (value * 1000) - 100

    @isSetup = true

  disable: ->
    @isSetup = false
    atom.config.set "activate-power-mode.flow", "default" if @breakCombo
    @activationThresholdObserver?.dispose()
    @superExclamationObserver?.dispose()
    @onNextLevelObserver?.dispose()
    @exclamationObserver?.dispose()
    @breakComboObserver?.dispose()
    @multiplierObserver?.dispose()
    @timeLapseObserver?.dispose()
    @onDeleteObserver?.dispose()
    @onNewMaxObserver?.dispose()
    @SElapseObserver?.dispose()
    @displayObserver?.dispose()
    @volumeObserver?.dispose()
    @ElapseObserver?.dispose()
    @styleObserver?.dispose()
    @typesObserver?.dispose()
    @flowObserver?.dispose()
    @pathObserver?.dispose()
    @muteObserver?.dispose()

  refreshFiles: ->
    @exclamations = if fs.existsSync(@path) then @getAudioFiles() else null

  getAudioFiles: ->
    allFiles = fs.readdirSync(@path)
    file = 0
    while(allFiles[file])
      fileName = allFiles[file++]
      fileExtencion = fileName.split('.').pop()
      continue if(fileExtencion is "mp3") or (fileExtencion is "MP3")
      continue if(fileExtencion is "wav") or (fileExtencion is "WAV")
      continue if(fileExtencion is "3gp") or (fileExtencion is "3GP")
      continue if(fileExtencion is "m4a") or (fileExtencion is "M4A")
      continue if(fileExtencion is "webm") or (fileExtencion is "WEBM")
      allFiles.splice(--file, 1)
      break if file is allFiles.length

    return if (allFiles.length > 0) then allFiles else null

  setConfig: (config, value) ->
    atom.config.set "activate-killer-instinct-mode.#{config}", value
