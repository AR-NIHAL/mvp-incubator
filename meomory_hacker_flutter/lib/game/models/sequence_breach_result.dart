import '../controllers/sequence_breach_scoring.dart';

class SequenceBreachResult {
  const SequenceBreachResult({
    required this.levelId,
    required this.success,
    required this.completedSteps,
    required this.totalSteps,
    required this.elapsedSeconds,
    this.score,
    this.completedAtEpochMs,
  });

  final String levelId;
  final bool success;
  final int completedSteps;
  final int totalSteps;
  final double elapsedSeconds;
  final int? score;
  final int? completedAtEpochMs;

  int get resolvedScore =>
      score ??
      SequenceBreachScoring.calculateScore(
        success: success,
        completedSteps: completedSteps,
        totalSteps: totalSteps,
        elapsedSeconds: elapsedSeconds,
      );

  int get accuracyPercent => SequenceBreachScoring.accuracyPercent(
    completedSteps: completedSteps,
    totalSteps: totalSteps,
  );

  Map<String, Object?> toMap() {
    return {
      'levelId': levelId,
      'success': success,
      'completedSteps': completedSteps,
      'totalSteps': totalSteps,
      'elapsedSeconds': elapsedSeconds,
      'score': resolvedScore,
      'completedAtEpochMs': completedAtEpochMs,
    };
  }

  factory SequenceBreachResult.fromMap(Map<dynamic, dynamic> map) {
    return SequenceBreachResult(
      levelId: map['levelId'] as String? ?? 'unknown-level',
      success: map['success'] as bool? ?? false,
      completedSteps: map['completedSteps'] as int? ?? 0,
      totalSteps: map['totalSteps'] as int? ?? 0,
      elapsedSeconds: (map['elapsedSeconds'] as num?)?.toDouble() ?? 0,
      score: map['score'] as int?,
      completedAtEpochMs: map['completedAtEpochMs'] as int?,
    );
  }

  SequenceBreachResult copyWith({
    String? levelId,
    bool? success,
    int? completedSteps,
    int? totalSteps,
    double? elapsedSeconds,
    int? score,
    int? completedAtEpochMs,
  }) {
    return SequenceBreachResult(
      levelId: levelId ?? this.levelId,
      success: success ?? this.success,
      completedSteps: completedSteps ?? this.completedSteps,
      totalSteps: totalSteps ?? this.totalSteps,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      score: score ?? this.score,
      completedAtEpochMs: completedAtEpochMs ?? this.completedAtEpochMs,
    );
  }
}
