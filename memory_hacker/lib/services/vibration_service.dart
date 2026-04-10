import 'package:vibration/vibration.dart';

class VibrationService {
  Future<void> pulse({required bool enabled}) async {
    if (!enabled) {
      return;
    }
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 50, amplitude: 128);
    }
  }

  Future<void> error({required bool enabled}) async {
    if (!enabled) {
      return;
    }
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        pattern: [0, 80, 40, 120],
        intensities: [0, 170, 0, 255],
      );
    }
  }
}
