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

  customAudio: (pathtoaudio) ->
    allFiles = fs.readdirSync(pathtoaudio.toString())
    file = 0
    while(allFiles[file])
      fileName = allFiles[file++]
      fileExtencion = fileName.split('.').pop();
      continue if(fileExtencion is "mp3") or (fileExtencion is "MP3")
      continue if(fileExtencion is "wav") or (fileExtencion is "WAV")
      continue if(fileExtencion is "3gp") or (fileExtencion is "3GP")
      continue if(fileExtencion is "m4a") or (fileExtencion is "M4A")
      continue if(fileExtencion is "webm") or (fileExtencion is "WEBM")
      allFiles.splice(--file, 1)
      break if file is allFiles.length

    maxIndex = allFiles.length - 1
    minIndex = 0
    randomIndex = Math.floor(Math.random() * (maxIndex - minIndex + 1) + minIndex)

    fileName = (allFiles[randomIndex])

  setFile: (combo) ->
    return fileName = ("Triple Combo") if combo is 3
    return fileName = ("Super Combo") if combo > 3 and combo < 6
    return fileName = ("Hyper Combo") if combo > 5 and combo < 9
    return fileName = ("Brutal Combo") if combo > 8 and combo < 12
    return fileName = ("Master Combo") if combo > 11 and combo < 15
    return fileName = ("Blaster Combo") if combo > 14 and combo < 18
    return fileName = ("Awesome Combo") if combo > 17 and combo < 21
    return fileName = ("Monster Combo") if combo > 20 and combo < 24
    return fileName = ("King Combo") if combo > 23 and combo < 27
    return fileName = ("Killer Combo") if combo > 26 and combo < 30
    return fileName = ("Ultra Combo") if combo >= 30
    fileName = null

  getConfig: (config) ->
    atom.config.get "activate-background-exclamation.playBackgroundexclamation.#{config}"

  setConfig: (config, value) ->
    atom.config.set("activate-background-exclamation.playBackgroundexclamation.#{config}", value)
