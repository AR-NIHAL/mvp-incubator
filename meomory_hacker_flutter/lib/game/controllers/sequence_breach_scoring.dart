import 'dart:math';

abstract final class SequenceBreachScoring {
  static int accuracyPercent({
    required int completedSteps,
    required int totalSteps,
  }) {
    if (totalSteps <= 0) {
      return 0;
    }

    final ratio = completedSteps / totalSteps;
    return (ratio * 100).round().clamp(0, 100);
  }

  static int calculateScore({
    required bool success,
    required int completedSteps,
    required int totalSteps,
    required double elapsedSeconds,
  }) {
    final progressScore = completedSteps * 100;
    final completionBonus = success ? totalSteps * 120 : 0;
    final timeBonus = max(
      0,
      (success ? 280 : 120) - (elapsedSeconds * (success ? 24 : 14)).round(),
    );

    return progressScore + completionBonus + timeBonus;
  }
}
