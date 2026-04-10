/// Describes how hard a level should feel.
class LevelConfig {
  const LevelConfig({
    required this.levelNumber,
    required this.sequenceLength,
    required this.previewStepMs,
    required this.totalTimeSeconds,
    required this.tokenCount,
  });

  final int levelNumber;
  final int sequenceLength;
  final int previewStepMs;
  final int totalTimeSeconds;
  final int tokenCount;
}
