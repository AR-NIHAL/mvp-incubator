import '../../../game/models/sequence_breach_progression_state.dart';
import '../../../game/models/sequence_breach_result.dart';
import '../../../game/providers/sequence_breach_level_catalog.dart';

class ResultsViewData {
  const ResultsViewData({
    required this.headline,
    required this.statusLabel,
    required this.levelTitle,
    required this.levelId,
    required this.elapsedLabel,
    required this.scoreLabel,
    required this.accuracyLabel,
    required this.stepsLabel,
    required this.outcomeSummary,
    required this.bestResultMessage,
    required this.progressionMessage,
    required this.primaryActionLabel,
    required this.primaryActionLevelId,
    required this.showPrimaryAsNext,
  });

  final String headline;
  final String statusLabel;
  final String levelTitle;
  final String levelId;
  final String elapsedLabel;
  final String scoreLabel;
  final String accuracyLabel;
  final String stepsLabel;
  final String outcomeSummary;
  final String bestResultMessage;
  final String progressionMessage;
  final String primaryActionLabel;
  final String primaryActionLevelId;
  final bool showPrimaryAsNext;
}

ResultsViewData buildResultsViewData({
  required SequenceBreachResult result,
  required SequenceBreachProgressionState progression,
}) {
  final level = sequenceBreachLevelById(result.levelId);
  final nextLevel = nextSequenceBreachLevel(result.levelId);
  final canAdvance =
      result.success &&
      nextLevel != null &&
      progression.isUnlocked(nextLevel.id);
  final bestResult = progression.resultFor(result.levelId);
  final isCurrentBest = bestResult != null && _sameResult(bestResult, result);

  return ResultsViewData(
    headline: result.success ? 'Sequence breached' : 'Trace rejected',
    statusLabel: result.success ? 'MISSION CLEAR' : 'MISSION FAILED',
    levelTitle: level?.title ?? 'Unknown Mission',
    levelId: result.levelId,
    elapsedLabel: _formatElapsed(result.elapsedSeconds),
    scoreLabel: result.resolvedScore.toString(),
    accuracyLabel: '${result.accuracyPercent}%',
    stepsLabel: '${result.completedSteps}/${result.totalSteps}',
    outcomeSummary: result.success
        ? 'You reconstructed the full pattern before the signal window closed.'
        : 'The run ended before the full pattern was reconstructed.',
    bestResultMessage: _buildBestResultMessage(
      currentResult: result,
      bestResult: bestResult,
      isCurrentBest: isCurrentBest,
    ),
    progressionMessage: _buildProgressionMessage(
      result: result,
      nextLevelTitle: nextLevel?.title,
      canAdvance: canAdvance,
    ),
    primaryActionLabel: canAdvance ? 'Next Mission' : 'Replay Mission',
    primaryActionLevelId: canAdvance ? nextLevel.id : result.levelId,
    showPrimaryAsNext: canAdvance,
  );
}

String _buildBestResultMessage({
  required SequenceBreachResult currentResult,
  required SequenceBreachResult? bestResult,
  required bool isCurrentBest,
}) {
  if (bestResult == null) {
    return 'First recorded run for this mission.';
  }

  if (isCurrentBest) {
    return currentResult.success
        ? 'New best run saved at ${_formatElapsed(currentResult.elapsedSeconds)} for ${currentResult.resolvedScore} pts.'
        : 'Best failed attempt updated at ${currentResult.resolvedScore} pts with ${currentResult.completedSteps}/${currentResult.totalSteps} steps.';
  }

  return 'Best remains ${bestResult.resolvedScore} pts at ${_formatElapsed(bestResult.elapsedSeconds)} with ${bestResult.completedSteps}/${bestResult.totalSteps} steps.';
}

String _buildProgressionMessage({
  required SequenceBreachResult result,
  required String? nextLevelTitle,
  required bool canAdvance,
}) {
  if (result.success && canAdvance && nextLevelTitle != null) {
    return 'Unlocked next mission: $nextLevelTitle.';
  }

  if (result.success) {
    return 'Mission progression remains stable. Replay for a cleaner run.';
  }

  return 'Replay this mission to unlock the next node.';
}

bool _sameResult(SequenceBreachResult left, SequenceBreachResult right) {
  return left.levelId == right.levelId &&
      left.success == right.success &&
      left.completedSteps == right.completedSteps &&
      left.totalSteps == right.totalSteps &&
      left.elapsedSeconds == right.elapsedSeconds;
}

String _formatElapsed(double seconds) {
  final duration = Duration(milliseconds: (seconds * 1000).round());
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final tenths = ((duration.inMilliseconds.remainder(1000)) ~/ 100).toString();
  return '$minutes:$secs.$tenths';
}
