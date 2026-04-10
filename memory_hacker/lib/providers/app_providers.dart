import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/pattern_generator_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../services/vibration_service.dart';

final patternGeneratorProvider = Provider<PatternGeneratorService>((ref) {
  return PatternGeneratorService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService();
  ref.onDispose(service.dispose);
  return service;
});

final vibrationServiceProvider = Provider<VibrationService>((ref) {
  return VibrationService();
});
