import 'dart:math';

import '../models/level_config.dart';
import '../models/pattern_token.dart';

/// Builds dynamic level values and random sequences.
class PatternGeneratorService {
  final Random _random = Random();

  LevelConfig getConfigForLevel(int level) {
    final safeLevel = level.clamp(1, 99);
    final sequenceLength = 3 + safeLevel - 1;
    final previewStepMs = max(320, 950 - (safeLevel * 40));
    final totalTimeSeconds = max(4, 9 - (safeLevel ~/ 3));
    final tokenCount = min(4, 2 + ((safeLevel + 1) ~/ 2));

    return LevelConfig(
      levelNumber: safeLevel,
      sequenceLength: sequenceLength,
      previewStepMs: previewStepMs,
      totalTimeSeconds: totalTimeSeconds,
      tokenCount: tokenCount,
    );
  }

  List<PatternToken> buildSequence(LevelConfig config) {
    final pool =
        PatternToken.values.take(config.tokenCount).toList(growable: false);
    return List<PatternToken>.generate(
      config.sequenceLength,
      (_) => pool[_random.nextInt(pool.length)],
      growable: false,
    );
  }
}
