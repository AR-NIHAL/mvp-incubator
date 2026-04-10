import '../models/sequence_breach_level_config.dart';

const allSequenceBreachLevels = <SequenceBreachLevelConfig>[
  SequenceBreachLevelConfig(
    id: 'boot-sequence',
    title: 'Boot Sequence',
    subtitle: 'Learn the recall loop with a short diagonal breach.',
    difficultyLabel: 'Easy',
    sequence: [0, 4, 8],
    inputTimeLimit: 8,
  ),
  SequenceBreachLevelConfig(
    id: 'signal-trace',
    title: 'Signal Trace',
    subtitle: 'Build confidence with a four-step outer-ring pattern.',
    difficultyLabel: 'Easy',
    sequence: [1, 2, 5, 8],
    playbackHighlightDuration: 0.48,
    inputTimeLimit: 8,
  ),
  SequenceBreachLevelConfig(
    id: 'ghost-cache',
    title: 'Ghost Cache',
    subtitle: 'Keep the center in memory while the path doubles back.',
    difficultyLabel: 'Easy',
    sequence: [4, 0, 3, 4],
    playbackHighlightDuration: 0.46,
    inputTimeLimit: 7.6,
  ),
  SequenceBreachLevelConfig(
    id: 'firewall-handshake',
    title: 'Firewall Handshake',
    subtitle: 'Shift to a five-step trace that crosses the board.',
    difficultyLabel: 'Medium',
    sequence: [0, 2, 4, 6, 8],
    playbackHighlightDuration: 0.44,
    inputTimeLimit: 7.2,
  ),
  SequenceBreachLevelConfig(
    id: 'null-sector',
    title: 'Null Sector',
    subtitle: 'A broken perimeter route punishes shallow chunking.',
    difficultyLabel: 'Medium',
    sequence: [6, 3, 0, 1, 2],
    playbackHighlightDuration: 0.42,
    inputTimeLimit: 7,
  ),
  SequenceBreachLevelConfig(
    id: 'packet-drift',
    title: 'Packet Drift',
    subtitle: 'The path pivots through the center twice under tighter timing.',
    difficultyLabel: 'Medium',
    sequence: [7, 4, 1, 4, 5, 8],
    playbackHighlightDuration: 0.4,
    playbackGapDuration: 0.16,
    inputTimeLimit: 6.8,
  ),
  SequenceBreachLevelConfig(
    id: 'mirror-break',
    title: 'Mirror Break',
    subtitle: 'Similar left and right beats hide one critical asymmetry.',
    difficultyLabel: 'Medium',
    sequence: [0, 1, 4, 1, 2, 5],
    playbackHighlightDuration: 0.38,
    playbackGapDuration: 0.16,
    inputTimeLimit: 6.4,
  ),
  SequenceBreachLevelConfig(
    id: 'noise-injection',
    title: 'Noise Injection',
    subtitle: 'Longer recall demand with reduced observation time.',
    difficultyLabel: 'Hard',
    sequence: [8, 5, 2, 4, 6, 3, 0],
    playbackHighlightDuration: 0.36,
    playbackGapDuration: 0.14,
    inputTimeLimit: 6.2,
  ),
  SequenceBreachLevelConfig(
    id: 'trace-collapse',
    title: 'Trace Collapse',
    subtitle:
        'The sequence loops across opposite corners before the timer bites.',
    difficultyLabel: 'Hard',
    sequence: [2, 4, 6, 4, 8, 7, 3],
    playbackHighlightDuration: 0.34,
    playbackGapDuration: 0.14,
    inputTimeLimit: 5.8,
  ),
  SequenceBreachLevelConfig(
    id: 'core-breach',
    title: 'Core Breach',
    subtitle: 'A full-length final route for the MVP progression slice.',
    difficultyLabel: 'Hard',
    sequence: [0, 4, 8, 7, 3, 1, 5, 2],
    playbackHighlightDuration: 0.32,
    playbackGapDuration: 0.12,
    inputTimeLimit: 5.6,
  ),
];

SequenceBreachLevelConfig? sequenceBreachLevelById(String levelId) {
  for (final level in allSequenceBreachLevels) {
    if (level.id == levelId) {
      return level;
    }
  }
  return null;
}

SequenceBreachLevelConfig? nextSequenceBreachLevel(String levelId) {
  final currentIndex = allSequenceBreachLevels.indexWhere(
    (level) => level.id == levelId,
  );
  if (currentIndex < 0 || currentIndex + 1 >= allSequenceBreachLevels.length) {
    return null;
  }
  return allSequenceBreachLevels[currentIndex + 1];
}
