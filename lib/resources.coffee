path = require "path"
fs = require "fs"

module.exports =
  exclamation: null
  isPlaying: false
  isSetup: false
  audioFiles: null

  disable: ->
    if @exclamation != null and @isSetup is true
      @exclamation.pause
      @exclamationPathObserver?.dispose()
      @exclamationVolumeObserver?.dispose()
      @pathToExclamation = ""
      @isSetup = false
      @exclamation = null
      @audioFiles = null
      @isPlaying = false

  setup: ->
    @exclamationPathObserver?.dispose()
    @exclamationPathObserver = atom.config.observe 'activate-background-exclamation.playBackgroundexclamation.exclamationPath', (value) =>
      if value is "../sounds/exclamations/"
        @pathToExclamation = path.join(__dirname, value)
      else
        @pathToExclamation = value

      if fs.existsSync(@pathToExclamation)
        @audioFiles = @getAudioFiles()
      else
        @audioFiles = null

      if @audioFiles is null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("exclamationPath","../sounds/exclamations/")
      else
        @exclamation.pause() if @exclamation != null and @isPlaying
        @exclamation = new Audio(@pathToExclamation + @audioFiles[0])
        @exclamation.volume = (@getConfig("exclamationVolume") * 0.01)

    @exclamationVolumeObserver?.dispose()
    @exclamationVolumeObserver = atom.config.observe 'activate-background-exclamation.playBackgroundexclamation', (value) =>
      @exclamation.volume = (@getConfig("exclamationVolume") * 0.01) if @exclamation != null

    @isSetup = true

  getAudioFiles: ->
    allFiles = fs.readdirSync(@pathToExclamation)
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

  getConfig: (config) ->
    atom.config.get "activate-background-exclamation.playBackgroundexclamation.#{config}"

  setConfig: (config, value) ->
    atom.config.set("activate-background-exclamation.playBackgroundexclamation.#{config}", value)
