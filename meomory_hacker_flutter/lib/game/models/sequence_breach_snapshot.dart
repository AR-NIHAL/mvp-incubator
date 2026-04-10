import 'sequence_breach_phase.dart';

class SequenceBreachSnapshot {
  const SequenceBreachSnapshot({
    required this.phase,
    required this.levelId,
    required this.totalSteps,
    required this.completedSteps,
    required this.remainingTime,
    required this.statusLabel,
  });

  const SequenceBreachSnapshot.initial({
    required String levelId,
    required int totalSteps,
  }) : this(
         phase: SequenceBreachPhase.booting,
         levelId: levelId,
         totalSteps: totalSteps,
         completedSteps: 0,
         remainingTime: 0,
         statusLabel: 'Booting sequence',
       );

  final SequenceBreachPhase phase;
  final String levelId;
  final int totalSteps;
  final int completedSteps;
  final double remainingTime;
  final String statusLabel;

  bool get isInteractable => phase == SequenceBreachPhase.input;
  bool get isFinished =>
      phase == SequenceBreachPhase.success ||
      phase == SequenceBreachPhase.failure;

  SequenceBreachSnapshot copyWith({
    SequenceBreachPhase? phase,
    String? levelId,
    int? totalSteps,
    int? completedSteps,
    double? remainingTime,
    String? statusLabel,
  }) {
    return SequenceBreachSnapshot(
      phase: phase ?? this.phase,
      levelId: levelId ?? this.levelId,
      totalSteps: totalSteps ?? this.totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
      remainingTime: remainingTime ?? this.remainingTime,
      statusLabel: statusLabel ?? this.statusLabel,
    );
  }
}
