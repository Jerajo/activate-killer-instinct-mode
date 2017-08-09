module.exports =

  comboMode:
    type: "object"
    properties:
      style:
        title: "Combo Mode - Style"
        description: "Sets the settings to have pre-configured style or use custom settings."
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
        default: true
        order: 2

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
            title: "Combo Mode Custom Exclamations - Enabled"
            description: 'To aply this settings "Combo Mode - Style" has to be Custom'
            type: "boolean"
            default: true
            order: 1

          exclamationType:
            title: "Combo Mode Custom Exclamations - Type and Lapse"
            description: "types: onlyText, onlyAudio, bouth. streakCount: min 10 max 100. (let in 0 to play at endStreak)."
            type: "string"
            default: "onlyText"
            enum: [
              {value: 'onlyText', description: 'Only Text'}
              {value: 'onlyAudio', description: 'Only Audio'}
              {value: 'bouth', description: 'Bouth'}
            ]

          exclamationEvery:
            title: "Combo Mode - Exclamation Every"
            description: "Shows an exclamation every streak count."
            type: "integer"
            default: 10
            minimum: 1
            maximum: 100

          textsOrPath:
            title: "Combo Mode Custom Exclamations - Exclamation Texts or Path"
            description: 'Custom exclamations to show (randomized) or Path to exclamations audiofiles. (Add "/" or, "\\" at the end of the path).
            Note: exclamation will not apear if type is onlyText and text or path is a path also if type is onlyAudio or bouth and texts or path are texts.'
            type: "array"
            default: ["Super!", "Radical!", "Fantastic!", "Great!", "OMG", "Whoah!", ":O", "Nice!", "Splendid!", "Wild!", "Grand!", "Impressive!", "Stupendous!", "Extreme!", "Awesome!"]
            order: 3
