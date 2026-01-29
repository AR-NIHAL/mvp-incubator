import 'package:hive/hive.dart';

class SettingsStore {

  static const _boxName = 'settings_box';
  static const _firstOpenKey = 'isFirstOpen';
  static Box get _box => Hive.box(_boxName);
  static bool get isFirstOpen =>
      (_box.get(_firstOpenKey) as bool?) ?? true;
      
  static Future<void> setFirstOpenFalse() async {
    await _box.put(_firstOpenKey, false);
  }

  static Future<void> reset() async {
    await _box.delete(_firstOpenKey);
  }
}