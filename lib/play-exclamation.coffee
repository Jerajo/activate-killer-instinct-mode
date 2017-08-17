module.exports =
  path: ""
  sound: null
  exclamation: ""
  volume: 0
  isPlaying: false
  audioFiles: null

  enable: (path) ->
    @path = path
    @audioFiles = @getAudioFiles()
    @volumeObserver?.dispose()
    @volumeObserver = atom.config.observe 'activate-killer-instinct-mode.comboMode.volume', (value) =>
      @volume = (value * 0.01)

  setup: (path) ->
    @path = path
    @audioFiles = @getAudioFiles()

  desable: ->
    @volumeObserver?.dispose()
    @isPlaying = false
    @audioFiles = null
    @exclamation = ""
    @sound = null
    @path = ""

  play: (path, style, combo = -1) ->
    ispath = if path.length - 1 == path.lastIndexOf('\\') then true else false
    if not ispath
      console.log "se reconose como no path: " + path
      start = path.lastIndexOf('\\') + 1;
      end = path.lastIndexOf('.') - start;
      @exclamation = path.substr(start, end);
      @sound = new Audio(path)
    else
      @setup(path) if @path != path
      console.log "El path es: " + @path
      console.log "El style es: " + style
      console.log "El streak es: " + combo
      if style is "killerInstinct"
        @exclamation = @killerInstinctExclamation(combo)
        extencion = ".wav"
        @sound = new Audio(@path + @exclamation + extencion)
      else
        @exclamation = @CustomExclamation()
        @sound = new Audio(@path + @exclamation)

      @exclamation = @exclamation.substr(0, @exclamation.lastIndexOf('.'))
      console.log "La exclamacion es: " + @exclamation

    @sound.volume = @volume
    @isPlaying = true
    @sound.play()
    @sound.onended = =>
      @isPlaying = false
    return (@exclamation + "!")

  getAudioFiles: ->
    allFiles = fs.readdirSync(@path)
    file = 0
    while(allFiles[file])
      console.log allFiles[file]
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

  CustomExclamation: ->
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

  getConfig: (config) ->
    atom.config.get "activate-power-mode.comboMode.#{config}"
