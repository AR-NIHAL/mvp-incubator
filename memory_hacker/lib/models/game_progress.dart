/// Saved player profile data.
class GameProgress {
  const GameProgress({
    required this.highScore,
    required this.unlockedLevel,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  factory GameProgress.initial() {
    return const GameProgress(
      highScore: 0,
      unlockedLevel: 1,
      soundEnabled: true,
      vibrationEnabled: true,
    );
  }

  final int highScore;
  final int unlockedLevel;
  final bool soundEnabled;
  final bool vibrationEnabled;

  GameProgress copyWith({
    int? highScore,
    int? unlockedLevel,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return GameProgress(
      highScore: highScore ?? this.highScore,
      unlockedLevel: unlockedLevel ?? this.unlockedLevel,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
