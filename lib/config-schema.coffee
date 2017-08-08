module.exports =

  playIntroAudio:
    type: "object"
    order: 2
    properties:
      enabled:
        title: "Play Intro Audio - Enabled"
        description: "Play audio clip on/off."
        type: "boolean"
        default: false
        order: 1

      audioPath:
        title: "Play Intro Audio - Path to Audioclip"
        description: "Path to audioclip played at keystroke."
        type: "string"
        default: '../sounds/intro.wav'

      volume:
        title: "Play Intro Audio - Volume"
        description: "Volume of the audio clip played at keystroke."
        type: "integer"
        default: 50
        minimum: 0
        maximum: 100

  playBackgroundMusic:
    type: "object"
    order: 3
    properties:
      enabled:
        title: "Background Music - Enabled"
        description: "Play Background Music on/off."
        type: "boolean"
        default: true
        order: 1

      musicPath:
        title: "Background Music - Path to Audio"
        description: "Path to Music Tracks played in combo Mode."
        type: "string"
        default: '../sounds/musics/'
        order: 2

      musicVolume:
        title: "Background Music - Volume"
        description: "Volume of the Music Track played in combo Mode."
        type: "integer"
        default: 50
        minimum: 0
        maximum: 100
        order: 3

  actions:
    order: 4
    type: "object"
    properties:
      autoplay:
        title: "Music Player - Actions - Auto-play"
        description: "Auto play the music after the action execution, wont apply on stop and pause actions. If pause option is enabled on action streak ends this setting won't apply on that event."
        type: "boolean"
        default: true
        order: 1

      duringStreak:
        order: 2
        type: "object"
        properties:
          action:
            title: "Music Player - Action During Streak"
            description: "Action executed during streak."
            type: "string"
            default: 'none'
            enum: [
              {value: 'none', description: 'None'}
              {value: 'play', description: 'Play Music'}
              {value: 'pause', description: 'Pasue Music'}
              {value: 'stop', description: 'Stop Music'}
              {value: 'repeat', description: 'Repeat Music'}
              {value: 'previous', description: 'Previous Music'}
              {value: 'next', description: 'Next Music'}
            ]
            order: 1

          typeLapse:
            title: "Music Player - Action During Streak - Type of Lapse"
            description: "Type of lapse used for the action during streak."
            type: "string"
            default: 'streak'
            enum: [
              {value: 'streak', description: 'Streaks'}
              {value: 'time', description: 'Seconds'}
            ]
            order: 2

          lapse:
            title: "Music Player - Action During Streak - Lapse"
            description: "Lapse for acion execution on streaks or seconds."
            type: "number"
            default: 1000
            minimum: 10
            maximum: 100000
            order: 3

      endStreak:
        order: 2
        type: "object"
        properties:
          pause:
            title: "Music Player - Action On Streak End - Pause"
            description: "Pause the music when streak ends."
            type: "boolean"
            default: true
            order: 1

          action:
            title: "Music Player - Action On Streak End"
            description: "Action executed when the combo streak ends."
            type: "string"
            default: 'none'
            enum: [
              {value: 'none', description: 'None'}
              {value: 'stop', description: 'Stop Music'}
              {value: 'repeat', description: 'Repeat Music'}
              {value: 'previous', description: 'Previous Music'}
              {value: 'next', description: 'Next Music'}
            ]
            order: 2

      nextLevel:
        order: 3
        type: "object"
        properties:
          action:
            title: "Music Player - Action On Next Level"
            description: "Action executed when the combo level changes."
            type: "string"
            default: 'next'
            enum: [
              {value: 'none', description: 'None'}
              {value: 'play', description: 'Play Music'}
              {value: 'pause', description: 'Pasue Music'}
              {value: 'stop', description: 'Stop Music'}
              {value: 'repeat', description: 'Repeat Music'}
              {value: 'previous', description: 'Previous Music'}
              {value: 'next', description: 'Next Music'}
            ]

      endMusic:
        order: 4
        type: "object"
        properties:
          action:
            title: "Music Player - Action On Music End"
            description: "Action executed when music ends."
            type: "string"
            default: 'repeat'
            enum: [
              {value: 'none', description: 'None'}
              {value: 'play', description: 'Play Music'}
              {value: 'repeat', description: 'Repeat Music'}
              {value: 'previous', description: 'Previous Music'}
              {value: 'next', description: 'Next Music'}
            ]

      volumeChangeRate:
        title: "Music Player - Volume Change Rate"
        description: "Change Rate for Volume Up and Down actions."
        type: "integer"
        default: 10
        minimum: 1
        maximum: 100
