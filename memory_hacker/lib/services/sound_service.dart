import 'package:audioplayers/audioplayers.dart';

/// Placeholder sound support.
/// If you add files into assets/sounds later, wire them here.
class SoundService {
  SoundService() : _player = AudioPlayer();

  final AudioPlayer _player;

  Future<void> playTap({required bool enabled}) async {
    if (!enabled) {
      return;
    }
  }

  Future<void> playSuccess({required bool enabled}) async {
    if (!enabled) {
      return;
    }
  }

  Future<void> playError({required bool enabled}) async {
    if (!enabled) {
      return;
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
