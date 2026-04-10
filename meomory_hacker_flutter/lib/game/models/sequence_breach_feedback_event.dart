import 'sequence_breach_feedback_type.dart';

class SequenceBreachFeedbackEvent {
  const SequenceBreachFeedbackEvent({
    required this.type,
    this.levelId,
    this.stepIndex,
  });

  final SequenceBreachFeedbackType type;
  final String? levelId;
  final int? stepIndex;
}
