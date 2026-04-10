import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_progress.dart';

class StorageService {
  static const _highScoreKey = 'high_score';
  static const _unlockedLevelKey = 'unlocked_level';
  static const _soundEnabledKey = 'sound_enabled';
  static const _vibrationEnabledKey = 'vibration_enabled';

  Future<GameProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return GameProgress(
      highScore: prefs.getInt(_highScoreKey) ?? 0,
      unlockedLevel: prefs.getInt(_unlockedLevelKey) ?? 1,
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      vibrationEnabled: prefs.getBool(_vibrationEnabledKey) ?? true,
    );
  }

  Future<void> saveProgress(GameProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, progress.highScore);
    await prefs.setInt(_unlockedLevelKey, progress.unlockedLevel);
    await prefs.setBool(_soundEnabledKey, progress.soundEnabled);
    await prefs.setBool(_vibrationEnabledKey, progress.vibrationEnabled);
  }
}
