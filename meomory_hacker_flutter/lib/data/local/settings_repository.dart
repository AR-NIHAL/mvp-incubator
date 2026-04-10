import '../../game/models/settings_state.dart';
import 'local_storage_service.dart';

class SettingsRepository {
  SettingsRepository(this._storageService);

  final LocalStorageService _storageService;

  static const _settingsKey = 'app_settings';

  Future<SettingsState> loadSettings() async {
    final raw = _storageService.settingsBox.get(_settingsKey);
    if (raw is Map<dynamic, dynamic>) {
      return SettingsState.fromMap(raw);
    }

    const defaults = SettingsState.defaults();
    await saveSettings(defaults);
    return defaults;
  }

  Future<void> saveSettings(SettingsState state) async {
    await _storageService.settingsBox.put(_settingsKey, state.toMap());
  }
}
