import '../../game/controllers/sequence_breach_progression_logic.dart';
import '../../game/models/sequence_breach_level_config.dart';
import '../../game/models/sequence_breach_progression_state.dart';
import '../../game/models/sequence_breach_result.dart';
import 'local_storage_service.dart';

class ProgressionRepository {
  ProgressionRepository(this._storageService);

  final LocalStorageService _storageService;

  static const _progressionKey = 'sequence_breach_progression';

  Future<SequenceBreachProgressionState> loadProgression({
    required String firstLevelId,
  }) async {
    final raw = _storageService.progressionBox.get(_progressionKey);
    if (raw is Map<dynamic, dynamic>) {
      return SequenceBreachProgressionState.fromMap(
        raw,
        firstLevelId: firstLevelId,
      );
    }

    final initial = SequenceBreachProgressionState.initial(
      firstLevelId: firstLevelId,
    );
    await saveProgression(initial);
    return initial;
  }

  Future<void> saveProgression(SequenceBreachProgressionState state) async {
    await _storageService.progressionBox.put(_progressionKey, state.toMap());
  }

  Future<SequenceBreachProgressionState> recordResult({
    required SequenceBreachResult result,
    required List<SequenceBreachLevelConfig> catalog,
  }) async {
    final current = await loadProgression(firstLevelId: catalog.first.id);
    final updated = SequenceBreachProgressionLogic.applyResult(
      currentState: current,
      result: result,
      catalog: catalog,
    );
    await saveProgression(updated);
    return updated;
  }
}
