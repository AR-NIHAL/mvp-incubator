import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../models/settings_state.dart';
import '../models/sequence_breach_feedback_event.dart';
import '../models/sequence_breach_feedback_type.dart';
import 'gameplay_feedback_gate.dart';

class GameplayFeedbackService {
  GameplayFeedbackService({
    GameplayFeedbackGate? gate,
    AudioPlayer Function()? playerFactory,
  }) : _gate = gate ?? GameplayFeedbackGate(),
       _playerFactory = playerFactory ?? AudioPlayer.new;

  final GameplayFeedbackGate _gate;
  final AudioPlayer Function() _playerFactory;
  final Map<SequenceBreachFeedbackType, AudioPlayer> _players = {};

  Future<void> handleEvent({
    required SequenceBreachFeedbackEvent event,
    required SettingsState settings,
  }) async {
    if (!_gate.shouldEmit(event.type)) {
      return;
    }

    if (settings.soundOn) {
      unawaited(_playSound(event.type));
    }

    if (settings.hapticsOn) {
      unawaited(_playHaptic(event.type));
    }
  }

  void resetSessionFeedback() {
    _gate.reset();
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }

  Future<void> _playSound(SequenceBreachFeedbackType type) async {
    try {
      final player = _players.putIfAbsent(type, () {
        final audioPlayer = _playerFactory();
        unawaited(audioPlayer.setReleaseMode(ReleaseMode.stop));
        return audioPlayer;
      });
      await player.stop();
      await player.play(AssetSource(_assetPath(type)));
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<void> _playHaptic(SequenceBreachFeedbackType type) async {
    try {
      switch (type) {
        case SequenceBreachFeedbackType.playbackPulse:
          return;
        case SequenceBreachFeedbackType.correctTap:
          await HapticFeedback.selectionClick();
          return;
        case SequenceBreachFeedbackType.wrongTap:
          await HapticFeedback.heavyImpact();
          return;
        case SequenceBreachFeedbackType.success:
          await HapticFeedback.mediumImpact();
          return;
        case SequenceBreachFeedbackType.failure:
          await HapticFeedback.vibrate();
          return;
      }
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  String _assetPath(SequenceBreachFeedbackType type) {
    switch (type) {
      case SequenceBreachFeedbackType.playbackPulse:
        return 'audio/playback_pulse.wav';
      case SequenceBreachFeedbackType.correctTap:
        return 'audio/correct_tap.wav';
      case SequenceBreachFeedbackType.wrongTap:
        return 'audio/wrong_tap.wav';
      case SequenceBreachFeedbackType.success:
        return 'audio/success_sting.wav';
      case SequenceBreachFeedbackType.failure:
        return 'audio/failure_sting.wav';
    }
  }
}
