import 'package:flutter_test/flutter_test.dart';
import 'package:memory_hacker_flutter/game/controllers/gameplay_feedback_gate.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_feedback_type.dart';

void main() {
  test('gate suppresses rapid duplicate feedback events', () {
    var now = DateTime(2026, 4, 6, 12);
    final gate = GameplayFeedbackGate(now: () => now);

    expect(gate.shouldEmit(SequenceBreachFeedbackType.correctTap), isTrue);
    expect(gate.shouldEmit(SequenceBreachFeedbackType.correctTap), isFalse);

    now = now.add(const Duration(milliseconds: 90));

    expect(gate.shouldEmit(SequenceBreachFeedbackType.correctTap), isTrue);
  });

  test('gate tracks each feedback type independently', () {
    final now = DateTime(2026, 4, 6, 12);
    final gate = GameplayFeedbackGate(now: () => now);

    expect(gate.shouldEmit(SequenceBreachFeedbackType.playbackPulse), isTrue);
    expect(gate.shouldEmit(SequenceBreachFeedbackType.success), isTrue);
  });
}
