import '../models/sequence_breach_feedback_type.dart';

class GameplayFeedbackGate {
  GameplayFeedbackGate({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<SequenceBreachFeedbackType, DateTime> _lastTriggeredAt = {};

  bool shouldEmit(SequenceBreachFeedbackType type) {
    final now = _now();
    final previous = _lastTriggeredAt[type];
    if (previous != null && now.difference(previous) < _minimumGap(type)) {
      return false;
    }

    _lastTriggeredAt[type] = now;
    return true;
  }

  void reset() {
    _lastTriggeredAt.clear();
  }

  Duration _minimumGap(SequenceBreachFeedbackType type) {
    switch (type) {
      case SequenceBreachFeedbackType.playbackPulse:
        return const Duration(milliseconds: 45);
      case SequenceBreachFeedbackType.correctTap:
        return const Duration(milliseconds: 75);
      case SequenceBreachFeedbackType.wrongTap:
        return const Duration(milliseconds: 140);
      case SequenceBreachFeedbackType.success:
      case SequenceBreachFeedbackType.failure:
        return const Duration(milliseconds: 220);
    }
  }
}
