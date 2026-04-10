import 'package:flutter_test/flutter_test.dart';
import 'package:memory_hacker_flutter/game/models/settings_state.dart';

void main() {
  test(
    'settings state preserves tutorial completion through map round trip',
    () {
      const state = SettingsState(
        soundOn: true,
        hapticsOn: false,
        reducedMotion: true,
        highContrast: false,
        sequenceBreachTutorialSeen: true,
      );

      final restored = SettingsState.fromMap(state.toMap());

      expect(restored.sequenceBreachTutorialSeen, isTrue);
      expect(restored.reducedMotion, isTrue);
      expect(restored.hapticsOn, isFalse);
    },
  );
}
