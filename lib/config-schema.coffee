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

      breakCombo:
        title: "Combo Mode - Combo Breaker On Delete"
        description: "Reset the current streak by pressing backspace. Note: the flow has to be Combo Breaker to apply this setting."
        type: "boolean"
        default: false
        order: 2

      lapse:
        title: "Exclamation - Display Lapse"
        description: "Lapse in streaks to display the exclamations (Let in 0 to desable)."
        type: "integer"
        default: 10
        minimum: 0
        maximum: 100000
        order: 1

      volume:
        title: "Combo Mode - Exclamation Volume"
        description: "Volume for exclamation sounds."
        type: "integer"
        default: 50
        minimum: 0
        maximum: 100

  customSettings:
    type: "object"
    properties:
      types:
        title: "Custom Settings - Exclamation Type"
        description: "Types of exclamations to be displayed."
        type: "string"
        default: "both"
        enum: [
          {value: 'onlyText', description: 'Only Text'}
          {value: 'onlyAudio', description: 'Only Audio'}
          {value: 'both', description: 'Both'}
        ]
        order: 1

      display:
        title: "Custom Settings - Exclamation Display"
        description: "Set when exclamations will display."
        type: "string"
        default: "endStreak"
        enum: [
          {value: 'duringStreak', description: 'During Streak'}
          {value: 'endStreak', description: 'End Streak'}
        ]
        order: 2

  customExclamations:
    type: "object"
    properties:
      path:
        title: "Custom Exclamations - Path"
        description: 'Path to exclamations audio files (Plays ramdomised). Copy and paste the full path.'
        type: "string"
        default: "../sounds/"
        order: 1

      onDelete:
        title: "Custom Exclamations - Combo Breaker"
        description: 'File inside of path to exclamations. Copy and paste the file name with his extension. (Leave it blank to desable it)'
        type: "string"
        default: ""
        order: 2

      onNextLevel:
        title: "Custom Exclamations - Next Level"
        description: 'File inside of path to exclamations. Copy and paste the file name with his extension. (Leave it blank to desable it)'
        type: "string"
        default: ""
        order: 3

      onNewMax:
        title: "Custom Exclamations - New Max"
        description: 'File inside of path to exclamations. Copy and paste the file name with his extension. (Leave it blank to desable it)'
        type: "string"
        default: ""
        order: 4

  superExclamation:
    type: "object"
    properties:
      lapse:
        title: "Super Exclamation - Display Lapse"
        description: "Lapse in streaks to display the super exclamation (Let in 0 to desable)."
        type: "integer"
        default: 100
        minimum: 0
        maximum: 100000
        order: 1

      path:
        title: "Super Exclamation - Path"
        description: 'File inside of path to exclamations to be played when current streak reaches the display lapse. Copy and paste the file name with his extension.'
        type: "string"
        default: "Yes oh my God.wav"
        order: 2

      mute:
        title: "Super Exclamation - Mute Enabled"
        description: 'Mute the music while playing the exclamations.
        Note: This require Activate-Background-Music package installed
        and the "Exclamations Type" needs to be "Only Audio" or "Both".'
        type: "boolean"
        default: true
        order: 3
