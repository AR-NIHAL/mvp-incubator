import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../models/sequence_breach_feedback_event.dart';
import '../models/sequence_breach_snapshot.dart';

class SequenceBreachGameController
    extends ValueNotifier<SequenceBreachSnapshot> {
  SequenceBreachGameController({
    required SequenceBreachSnapshot initialSnapshot,
  }) : super(initialSnapshot);

  VoidCallback? _restartAction;
  VoidCallback? _pauseAction;
  VoidCallback? _resumeAction;
  SequenceBreachSnapshot? _queuedSnapshot;
  final StreamController<SequenceBreachFeedbackEvent> _feedbackEvents =
      StreamController<SequenceBreachFeedbackEvent>.broadcast();

  Stream<SequenceBreachFeedbackEvent> get feedbackEvents =>
      _feedbackEvents.stream;

  void bind({
    VoidCallback? restartAction,
    VoidCallback? pauseAction,
    VoidCallback? resumeAction,
  }) {
    _restartAction = restartAction;
    _pauseAction = pauseAction;
    _resumeAction = resumeAction;
  }

  void updateSnapshot(SequenceBreachSnapshot snapshot) {
    if (_isSameSnapshot(value, snapshot)) {
      return;
    }

    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    if (schedulerPhase == SchedulerPhase.persistentCallbacks ||
        schedulerPhase == SchedulerPhase.transientCallbacks ||
        schedulerPhase == SchedulerPhase.midFrameMicrotasks) {
      _queuedSnapshot = snapshot;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final queued = _queuedSnapshot;
        if (queued == null || _isSameSnapshot(value, queued)) {
          return;
        }
        _queuedSnapshot = null;
        value = queued;
      });
      return;
    }

    value = snapshot;
  }

  void restartLevel() => _restartAction?.call();

  void pauseGame() => _pauseAction?.call();

  void resumeGame() => _resumeAction?.call();

  void emitFeedback(SequenceBreachFeedbackEvent event) {
    if (_feedbackEvents.isClosed) {
      return;
    }
    _feedbackEvents.add(event);
  }

  @override
  void dispose() {
    _feedbackEvents.close();
    super.dispose();
  }

  bool _isSameSnapshot(
    SequenceBreachSnapshot left,
    SequenceBreachSnapshot right,
  ) {
    return left.phase == right.phase &&
        left.levelId == right.levelId &&
        left.totalSteps == right.totalSteps &&
        left.completedSteps == right.completedSteps &&
        left.remainingTime == right.remainingTime &&
        left.statusLabel == right.statusLabel;
  }
}
