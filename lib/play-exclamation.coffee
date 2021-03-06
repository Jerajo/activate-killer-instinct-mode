fs = require 'fs'

module.exports =
  path: ""
  sound: null
  exclamation: ""
  volume: 0
  isPlaying: false
  audioFiles: null
  musicMute: false

  enable: (path) ->
    @path = path
    @audioFiles = @getAudioFiles()
    @volumeObserver?.dispose()
    @volumeObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.volume', (value) =>
      @volume = (value * 0.01)

  setup: (path) ->
    @path = path
    @audioFiles = @getAudioFiles()

  disable: ->
    @volumeObserver?.dispose()
    @isPlaying = false
    @audioFiles = null
    @exclamation = ""
    @sound = null
    @path = ""

  play: (path = "", config, combo = -1) ->
    ispath = if path.length - 1 is path.lastIndexOf('\\') or path.length - 1 is path.lastIndexOf('/') then yes else no
    unless ispath
      start = path.lastIndexOf('\\') + 1;
      end = path.lastIndexOf('.') - start;
      @exclamation = path.substr(start, end);
      @sound = new Audio(path)
    else
      @setup(path) if @path isnt path
      if combo >= 3 and config['style'] is 'killerInstinct'
        @exclamation = @killerInstinctExclamation(combo)
      else
        @exclamation = @customExclamation()
        @exclamation = @exclamation.substr(0, @exclamation.lastIndexOf('.'))

    return (@exclamation + "!") if config['types'] is "onlyText"
    @sound = new Audio(@path + @exclamation + ".wav")
    @sound.volume = @volume
    @isPlaying = yes
    @sound.play()

    @sound.onended = =>
      @isPlaying = false
      @muteTogle() if @musicMute

    return (@exclamation + "!")

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

    allFiles

  customExclamation: ->
    maxIndex = @audioFiles.length - 1
    minIndex = 0
    randomIndex = Math.floor(Math.random() * (maxIndex - minIndex + 1) + minIndex)
    fileName = (@audioFiles[randomIndex])

  killerInstinctExclamation: (combo) ->
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
    null

  muteTogle: (mute = false) ->
    @musicMute = mute
    target = atom.views.getView atom.workspace
    commandName = "activate-background-music:mute-toggle"
    atom.commands.dispatch target, commandName
