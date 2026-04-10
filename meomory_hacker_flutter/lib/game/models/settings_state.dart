class SettingsState {
  const SettingsState({
    required this.soundOn,
    required this.hapticsOn,
    required this.reducedMotion,
    required this.highContrast,
    required this.sequenceBreachTutorialSeen,
  });

  const SettingsState.defaults()
    : soundOn = true,
      hapticsOn = true,
      reducedMotion = false,
      highContrast = false,
      sequenceBreachTutorialSeen = false;

  final bool soundOn;
  final bool hapticsOn;
  final bool reducedMotion;
  final bool highContrast;
  final bool sequenceBreachTutorialSeen;

  SettingsState copyWith({
    bool? soundOn,
    bool? hapticsOn,
    bool? reducedMotion,
    bool? highContrast,
    bool? sequenceBreachTutorialSeen,
  }) {
    return SettingsState(
      soundOn: soundOn ?? this.soundOn,
      hapticsOn: hapticsOn ?? this.hapticsOn,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      sequenceBreachTutorialSeen:
          sequenceBreachTutorialSeen ?? this.sequenceBreachTutorialSeen,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'soundOn': soundOn,
      'hapticsOn': hapticsOn,
      'reducedMotion': reducedMotion,
      'highContrast': highContrast,
      'sequenceBreachTutorialSeen': sequenceBreachTutorialSeen,
    };
  }

  factory SettingsState.fromMap(Map<dynamic, dynamic> map) {
    return SettingsState(
      soundOn: map['soundOn'] as bool? ?? true,
      hapticsOn: map['hapticsOn'] as bool? ?? true,
      reducedMotion: map['reducedMotion'] as bool? ?? false,
      highContrast: map['highContrast'] as bool? ?? false,
      sequenceBreachTutorialSeen:
          map['sequenceBreachTutorialSeen'] as bool? ?? false,
    );
  }
}
