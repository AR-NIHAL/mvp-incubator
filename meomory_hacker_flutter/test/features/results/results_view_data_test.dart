import 'package:flutter_test/flutter_test.dart';
import 'package:memory_hacker_flutter/features/results/presentation/results_view_data.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_progression_state.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_result.dart';

void main() {
  test('success view data points to next mission when unlocked', () {
    const result = SequenceBreachResult(
      levelId: 'boot-sequence',
      success: true,
      completedSteps: 3,
      totalSteps: 3,
      elapsedSeconds: 4.3,
    );

    final progression = SequenceBreachProgressionState(
      unlockedLevelIds: {'boot-sequence', 'signal-trace'},
      bestResults: const {'boot-sequence': result},
    );

    final viewData = buildResultsViewData(
      result: result,
      progression: progression,
    );

    expect(viewData.primaryActionLabel, 'Next Mission');
    expect(viewData.primaryActionLevelId, 'signal-trace');
    expect(viewData.showPrimaryAsNext, isTrue);
    expect(viewData.scoreLabel, result.resolvedScore.toString());
    expect(viewData.accuracyLabel, '100%');
    expect(viewData.progressionMessage, contains('Unlocked next mission'));
  });

  test('failure view data stays on replay', () {
    const result = SequenceBreachResult(
      levelId: 'signal-trace',
      success: false,
      completedSteps: 2,
      totalSteps: 4,
      elapsedSeconds: 3.1,
    );

    final progression = SequenceBreachProgressionState(
      unlockedLevelIds: {'boot-sequence', 'signal-trace'},
      bestResults: const {'signal-trace': result},
    );

    final viewData = buildResultsViewData(
      result: result,
      progression: progression,
    );

    expect(viewData.primaryActionLabel, 'Replay Mission');
    expect(viewData.primaryActionLevelId, 'signal-trace');
    expect(viewData.showPrimaryAsNext, isFalse);
    expect(viewData.accuracyLabel, '50%');
    expect(viewData.bestResultMessage, contains('pts'));
  });
}
