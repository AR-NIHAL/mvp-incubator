import 'package:flutter_test/flutter_test.dart';
import 'package:memory_hacker_flutter/game/controllers/sequence_breach_progression_logic.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_progression_state.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_result.dart';
import 'package:memory_hacker_flutter/game/providers/sequence_breach_level_catalog.dart';

void main() {
  test('successful result unlocks the next level', () {
    final initial = SequenceBreachProgressionState.initial(
      firstLevelId: allSequenceBreachLevels.first.id,
    );
    const result = SequenceBreachResult(
      levelId: 'boot-sequence',
      success: true,
      completedSteps: 3,
      totalSteps: 3,
      elapsedSeconds: 4.2,
    );

    final updated = SequenceBreachProgressionLogic.applyResult(
      currentState: initial,
      result: result,
      catalog: allSequenceBreachLevels,
    );

    expect(updated.isUnlocked('boot-sequence'), isTrue);
    expect(updated.isUnlocked('signal-trace'), isTrue);
  });

  test('better successful result replaces a slower best result', () {
    const slower = SequenceBreachResult(
      levelId: 'boot-sequence',
      success: true,
      completedSteps: 3,
      totalSteps: 3,
      elapsedSeconds: 8.4,
      score: 640,
    );
    const faster = SequenceBreachResult(
      levelId: 'boot-sequence',
      success: true,
      completedSteps: 3,
      totalSteps: 3,
      elapsedSeconds: 5.1,
      score: 710,
    );

    expect(
      SequenceBreachProgressionLogic.isBetterResult(faster, slower),
      isTrue,
    );
    expect(
      SequenceBreachProgressionLogic.isBetterResult(slower, faster),
      isFalse,
    );
  });

  test('successful result beats failed best result', () {
    const failed = SequenceBreachResult(
      levelId: 'ghost-cache',
      success: false,
      completedSteps: 2,
      totalSteps: 4,
      elapsedSeconds: 3.8,
    );
    const success = SequenceBreachResult(
      levelId: 'ghost-cache',
      success: true,
      completedSteps: 4,
      totalSteps: 4,
      elapsedSeconds: 6.2,
    );

    expect(
      SequenceBreachProgressionLogic.isBetterResult(success, failed),
      isTrue,
    );
  });

  test('higher score beats equal-completion slower pace profile', () {
    const currentBest = SequenceBreachResult(
      levelId: 'null-sector',
      success: true,
      completedSteps: 5,
      totalSteps: 5,
      elapsedSeconds: 5.8,
      score: 840,
    );
    const candidate = SequenceBreachResult(
      levelId: 'null-sector',
      success: true,
      completedSteps: 5,
      totalSteps: 5,
      elapsedSeconds: 4.7,
      score: 872,
    );

    expect(
      SequenceBreachProgressionLogic.isBetterResult(candidate, currentBest),
      isTrue,
    );
  });
}
