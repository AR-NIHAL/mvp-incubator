import '../models/sequence_breach_level_config.dart';
import '../models/sequence_breach_progression_state.dart';
import '../models/sequence_breach_result.dart';

abstract final class SequenceBreachProgressionLogic {
  static bool isBetterResult(
    SequenceBreachResult candidate,
    SequenceBreachResult? currentBest,
  ) {
    if (currentBest == null) {
      return true;
    }

    if (candidate.success != currentBest.success) {
      return candidate.success;
    }

    if (candidate.resolvedScore != currentBest.resolvedScore) {
      return candidate.resolvedScore > currentBest.resolvedScore;
    }

    if (candidate.completedSteps != currentBest.completedSteps) {
      return candidate.completedSteps > currentBest.completedSteps;
    }

    return candidate.elapsedSeconds < currentBest.elapsedSeconds;
  }

  static SequenceBreachProgressionState applyResult({
    required SequenceBreachProgressionState currentState,
    required SequenceBreachResult result,
    required List<SequenceBreachLevelConfig> catalog,
  }) {
    final unlocked = {...currentState.unlockedLevelIds, result.levelId};
    final bestResults = {...currentState.bestResults};

    if (result.success) {
      final currentIndex = catalog.indexWhere(
        (level) => level.id == result.levelId,
      );
      if (currentIndex >= 0 && currentIndex + 1 < catalog.length) {
        unlocked.add(catalog[currentIndex + 1].id);
      }
    }

    final currentBest = currentState.bestResults[result.levelId];
    if (isBetterResult(result, currentBest)) {
      bestResults[result.levelId] = result;
    }

    return currentState.copyWith(
      unlockedLevelIds: unlocked,
      bestResults: bestResults,
    );
  }
}
