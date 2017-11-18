path = require 'path'
fs = require 'fs'

module.exports =
  conf: []
  isSetup: no
  exclamations: []

  setup: ->
    @activationThresholdObserver?.dispose()
    @activationThresholdObserver = atom.config.observe 'activate-power-mode.comboMode.activationThreshold', (lapse) =>
      if lapse[0] isnt "1"
        lapse.unshift("1")
        atom.config.set "activate-power-mode.comboMode.activationThreshold", lapse

    @typesObserver?.dispose()
    @typesObserver = atom.config.observe 'activate-killer-instinct-mode.customSettings.types', (value) =>
      @conf['types'] = value
      if @isSetup and @conf['style'] is "killerInstinct" and @conf['types'] isnt "both"
        @setConfig("comboMode.style", "custom")

    @displayObserver?.dispose()
    @displayObserver = atom.config.observe 'activate-killer-instinct-mode.customSettings.display', (value) =>
      @conf['display'] = value
      if @isSetup and @conf['style'] is "killerInstinct" and @conf['display'] is "duringStreak"
        @setConfig("comboMode.style", "custom")

    @pathObserver?.dispose()
    @pathObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.path', (value) =>
      if value is "../sounds/"
        @conf['path'] = path.join(__dirname, value)
      else
        if value[value.length-1] isnt '/' and value[value.length-1] isnt '\\'
          @conf['path'] = value + '\\'
        else if value[value.length-1] is '/'
          @conf['path'] = value.replace('/','\\')
        else @conf['path'] = value

        @setConfig("customExclamations.onDelete", "")
        @setConfig("customExclamations.onNextLevel", "")
        @setConfig("customExclamations.onNewMax", "")
        @setConfig("superExclamation.path", "")

      if @isSetup and @conf['style'] is "killerInstinct" and value isnt "../sounds/"
        @setConfig("comboMode.style", "custom")

      @refreshFiles()
      if @conf['exclamations'] is null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("customExclamations.path","../sounds/")

    @styleObserver?.dispose()
    @styleObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.style', (value) =>
      @conf['style'] = value
      if @isSetup and @conf['style'] is "killerInstinct"
        if not @conf['breakCombo']
          @setConfig("comboMode.breakCombo", on)
        if @conf['types'] isnt "both"
          @setConfig("customSettings.types", "both")
        if @conf['display'] isnt "endStreak"
          @setConfig("customSettings.display", "endStreak")
        if @conf['path'] isnt "../sounds/"
          @setConfig("customExclamations.path", "../sounds/")
        if @conf['onDelete'] isnt "Combo Breaker.wav"
          @setConfig("customExclamations.onDelete", "Combo Breaker.wav")
        if @conf['onNextLevel'] isnt "Level Up.wav"
          @setConfig("customExclamations.onNextLevel", "Level Up.wav")
        if @conf['onNewMax'] isnt "Maximum Combo.wav"
          @setConfig("customExclamations.onNewMax", "Maximum Combo.wav")
        if @conf['superExclamation'] isnt "Yes oh my God.wav"
          @setConfig("superExclamation.path", "Yes oh my God.wav")
        if atom.packages.isPackageActive("activate-background-music") and not @conf['mute']
          @setConfig("superExclamation.mute", on)

    @breakComboObserver?.dispose()
    @breakComboObserver = atom.config.observe "activate-killer-instinct-mode.comboMode.breakCombo", (value) =>
      @conf['breakCombo'] = value
      if @conf['breakCombo']
        atom.config.set "activate-power-mode.flow", "comboBreaker"
      else
        atom.config.set "activate-power-mode.flow", "default"

    @flowObserver?.dispose()
    @flowObserver = atom.config.observe "activate-power-mode.flow", (value) =>
      if value is "comboBreaker"
        atom.config.set "activate-killer-instinct-mode.comboMode.breakCombo", on
      else
        atom.config.set "activate-killer-instinct-mode.comboMode.breakCombo", off

    @multiplierObserver?.dispose()
    @multiplierObserver = atom.config.observe "activate-power-mode.comboMode.multiplier", (value) =>
      @conf['multiplier'] = value

    @onDeleteObserver?.dispose()
    @onDeleteObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onDelete', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then yes else no
        break if exits
      console.error "File didn't found on: " + @conf['path'] if not exits and value isnt ""
      @conf['onDelete'] = if value isnt "" and exits then @conf['path'] + value else null

    @onNextLevelObserver?.dispose()
    @onNextLevelObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onNextLevel', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then yes else no
        break if exits
      console.error "File didn't found on: " + @conf['path'] if not exits and value isnt ""
      @conf['onNextLevel'] = if value isnt "" and exits then @conf['path'] + value else null

    @onNewMaxObserver?.dispose()
    @onNewMaxObserver = atom.config.observe 'activate-killer-instinct-mode.customExclamations.onNewMax', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then yes else no
        break if exits
      console.error "File didn't found on: " + @conf['path'] if not exits and value isnt ""
      @conf['onNewMax'] = if value isnt "" and exits then @conf['path'] + value else null

    @superExclamationObserver?.dispose()
    @superExclamationObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.path', (value) =>
      @refreshFiles()
      for file of @exclamations
        exits = if value is @exclamations[file] then yes else no
        break if exits
      console.error "File didn't found on: " + @conf['path'] if not exits and value isnt ""
      @conf['superExclamation'] = if value isnt "" and exits then @conf['path'] + value else null

    @ElapseObserver?.dispose()
    @ElapseObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.lapse', (value) =>
      @conf['ELapse'] = value

    @SElapseObserver?.dispose()
    @SElapseObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.lapse', (value) =>
      @conf['SELapse'] = value

    @exclamationObserver?.dispose()
    @exclamationObserver = atom.config.observe 'activate-power-mode.comboMode.exclamationEvery', (value) =>
      if value isnt 0
        atom.config.set "activate-power-mode.comboMode.exclamationEvery", 0

    @muteObserver?.dispose()
    @muteObserver = atom.config.observe 'activate-killer-instinct-mode.superExclamation.mute', (value) =>
      installed = no
      packages = atom.packages.getAvailablePackageNames()

      for code, name of packages
        if name is "activate-background-music"
          installed = yes
          break
        else installed = no

      if (not installed or atom.packages.isPackageDisabled("activate-background-music")) and value
        return @setConfig("superExclamation.mute", off)
      @conf['mute'] = value

    @timeLapseObserver?.dispose()
    @timeLapseObserver = atom.config.observe "activate-power-mode.comboMode.streakTimeout", (value) =>
      @conf['timeLapse'] = (value * 1000) - 100

    @isSetup = yes

  disable: ->
    @isSetup = no
    atom.config.set "activate-power-mode.flow", "default" if @conf['breakCombo']
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
    @ElapseObserver?.dispose()
    @styleObserver?.dispose()
    @typesObserver?.dispose()
    @flowObserver?.dispose()
    @pathObserver?.dispose()
    @muteObserver?.dispose()
    exclamations: []
    conf: []

  refreshFiles: ->
    @exclamations = if fs.existsSync(@conf['path']) then @getAudioFiles() else null

  getAudioFiles: ->
    allFiles = fs.readdirSync(@conf['path'])
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
