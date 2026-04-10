import 'sequence_breach_result.dart';

class SequenceBreachProgressionState {
  const SequenceBreachProgressionState({
    required this.unlockedLevelIds,
    required this.bestResults,
  });

  factory SequenceBreachProgressionState.initial({
    required String firstLevelId,
  }) {
    return SequenceBreachProgressionState(
      unlockedLevelIds: {firstLevelId},
      bestResults: const {},
    );
  }

  final Set<String> unlockedLevelIds;
  final Map<String, SequenceBreachResult> bestResults;

  bool isUnlocked(String levelId) => unlockedLevelIds.contains(levelId);

  SequenceBreachResult? resultFor(String levelId) => bestResults[levelId];

  SequenceBreachProgressionState copyWith({
    Set<String>? unlockedLevelIds,
    Map<String, SequenceBreachResult>? bestResults,
  }) {
    return SequenceBreachProgressionState(
      unlockedLevelIds: unlockedLevelIds ?? this.unlockedLevelIds,
      bestResults: bestResults ?? this.bestResults,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'unlockedLevelIds': unlockedLevelIds.toList(),
      'bestResults': bestResults.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    };
  }

  factory SequenceBreachProgressionState.fromMap(
    Map<dynamic, dynamic> map, {
    required String firstLevelId,
  }) {
    final unlocked = ((map['unlockedLevelIds'] as List<dynamic>?) ?? const [])
        .whereType<String>()
        .toSet();
    final bestResultsMap =
        (map['bestResults'] as Map<dynamic, dynamic>?) ?? const {};

    final bestResults = <String, SequenceBreachResult>{};
    for (final entry in bestResultsMap.entries) {
      if (entry.key is! String || entry.value is! Map<dynamic, dynamic>) {
        continue;
      }
      bestResults[entry.key as String] = SequenceBreachResult.fromMap(
        entry.value as Map<dynamic, dynamic>,
      );
    }

    return SequenceBreachProgressionState(
      unlockedLevelIds: unlocked.isEmpty ? {firstLevelId} : unlocked,
      bestResults: bestResults,
    );
  }
}
