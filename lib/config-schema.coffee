module.exports =

  comboMode:
    type: "object"
    properties:
      style:
        title: "Combo Mode - Style"
        description: "Sets the style to use pre-configured or custom settings."
        type: "string"
        default: 'killerInstinct'
        enum: [
          {value: 'killerInstinct', description: 'Killer Instinct'}
          {value: 'custom', description: 'Custom'}
        ]
        order: 1

      multiplier:
        title: "Combo Mode - Multiplier"
        description: "Turn the multiplier on/off. (multiplier = streak * current level)."
        type: "boolean"
        default: false
        order: 2

      exclamationEvery:
        title: "Combo Mode - Exclamation Every"
        description: 'Shows an exclamation every streak count.'
        type: "integer"
        default: 10
        minimum: 1
        maximum: 100

      texts:
        title: "Combo Mode - Custom Exclamation"
        description: "Custom exclamations to show (randomized)."
        type: "array"
        default: ["Super!", "Radical!", "Fantastic!", "Great!", "OMG", "Whoah!", ":O", "Nice!", "Splendid!", "Wild!", "Grand!", "Impressive!", "Stupendous!", "Extreme!", "Awesome!"]
        order: 3

      exclamationVolume:
        title: "Combo Mode - Exclamation Volume"
        description: "Volume of the exclamation audio."
        type: "integer"
        default: 50
        minimum: 0
        maximum: 100
        order: 3

  customExclamations:
    type: "object"
    properties:
      enabled:
        title: "Custom Exclamations - Enabled"
        description: 'To apply this settings "Combo Mode - Style" has to be Custom'
        type: "boolean"
        default: false
        order: 1

      exclamationType:
        title: "Custom Exclamations - Type"
        description: "Types of exclamations to be displayed."
        type: "string"
        default: "onlyText"
        enum: [
          {value: 'onlyText', description: 'Only Text'}
          {value: 'onlyAudio', description: 'Only Audio'}
          {value: 'both', description: 'Both'}
        ]
        order: 2

      audioExclamations:
        type: "object"
        properties:
          pathToExclamations:
            title: "Audio Exclamations - Path To Exclamations"
            description: 'Path to exclamations audio files (Plays ramdomised).'
            type: "string"
            default: "../sounds/"
            order: 1

          exclamationOnDelete:
            title: "Audio Exclamations - Combo Breaker"
            description: 'Path to combo breaker audio file.'
            type: "string"
            default: "Combo Breaker.wav"
            order: 2

          exclamationOnNextLevel:
            title: "Audio Exclamations - Next Level"
            description: 'Path to next level audio file.'
            type: "string"
            default: "Level Up.wav"
            order: 3

          exclamationOnNewMas:
            title: "Audio Exclamations - New Max"
            description: 'Path to new max audio files.'
            type: "string"
            default: "Maxximun Power.wav"
            order: 4

          superExclamation:
            title: "Super Exclamation - Path"
            description: 'Path to super exclamation audio file.'
            type: "string"
            default: "Yes oh my God.wav"
            order: 2


  MusicPlayer:
    type: "object"
    properties:
      enabled:
        title: "Music Player - Mute Enabled"
        description: 'Mute the music while playing the exclamations.\n
        Note: This require Activate-Background-Music package installed\n
        and the "Exclamations Type" needs to be "Only Audio" or "Both".'
        type: "boolean"
        default: true
        order: 1

      chooseTheExclamations:
        type: "object"
        properties:
          duringStreak:
            title: "Music Mute -  DuringStreak"
            description: 'Mute the music while Normal Exclamations playing.
            (killer Instinct, Custom)'
            type: "boolean"
            default: true
            order: 1

          nextLevel:
            title: "Music Mute -  NextLevel"
            description: 'Mute the music while Next Level Exclamation is playing.'
            type: "boolean"
            default: true
            order: 2

          newMax:
            title: "Music Mute -  EndStreak"
            description: 'Mute the music while New Max Exclamation is playing.'
            type: "boolean"
            default: true
            order: 3

          superExclamation:
            title: "Music Mute - Super Exclamation"
            description: 'Mute the music while the Super Exclamation is playing.'
            type: "boolean"
            default: true
            order: 4
