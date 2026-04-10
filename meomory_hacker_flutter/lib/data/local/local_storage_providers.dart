import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../game/models/settings_state.dart';
import '../../game/models/sequence_breach_progression_state.dart';
import '../../game/providers/sequence_breach_level_catalog.dart';
import 'local_storage_service.dart';
import 'progression_repository.dart';
import 'settings_repository.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(localStorageServiceProvider).initialize();
});

final progressionRepositoryProvider = Provider<ProgressionRepository>((ref) {
  return ProgressionRepository(ref.read(localStorageServiceProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.read(localStorageServiceProvider));
});

final progressionStateProvider = FutureProvider<SequenceBreachProgressionState>(
  (ref) async {
    await ref.read(appBootstrapProvider.future);
    return ref
        .read(progressionRepositoryProvider)
        .loadProgression(firstLevelId: allSequenceBreachLevels.first.id);
  },
);

final settingsStateProvider = FutureProvider<SettingsState>((ref) async {
  await ref.read(appBootstrapProvider.future);
  return ref.read(settingsRepositoryProvider).loadSettings();
});
