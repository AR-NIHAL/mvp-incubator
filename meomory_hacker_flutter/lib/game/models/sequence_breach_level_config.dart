class SequenceBreachLevelConfig {
  const SequenceBreachLevelConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.difficultyLabel,
    required this.sequence,
    this.gridSize = 3,
    this.playbackLeadIn = 0.6,
    this.playbackHighlightDuration = 0.5,
    this.playbackGapDuration = 0.18,
    this.inputTimeLimit = 8,
  });

  final String id;
  final String title;
  final String subtitle;
  final String difficultyLabel;
  final int gridSize;
  final List<int> sequence;
  final double playbackLeadIn;
  final double playbackHighlightDuration;
  final double playbackGapDuration;
  final double inputTimeLimit;

  String get gridLabel => '${gridSize}x$gridSize Grid';
}
