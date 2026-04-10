import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:memory_hacker_flutter/app/app.dart';
import 'package:memory_hacker_flutter/data/local/local_storage_providers.dart';
import 'package:memory_hacker_flutter/game/models/settings_state.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_progression_state.dart';
import 'package:memory_hacker_flutter/game/providers/sequence_breach_level_catalog.dart';

void main() {
  testWidgets('first-time player sees tutorial overlay on gameplay entry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async {}),
          progressionStateProvider.overrideWith(
            (ref) async => SequenceBreachProgressionState.initial(
              firstLevelId: allSequenceBreachLevels.first.id,
            ),
          ),
          settingsStateProvider.overrideWith(
            (ref) async => const SettingsState.defaults(),
          ),
        ],
        child: const MemoryHackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Start Mission'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('1. Boot Sequence'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Watch. Remember. Repeat.'), findsAtLeastNWidgets(1));
    expect(find.text('Start Guided Run'), findsOneWidget);
  });

  testWidgets('pause sheet exposes resume restart and quit actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async {}),
          progressionStateProvider.overrideWith(
            (ref) async => SequenceBreachProgressionState.initial(
              firstLevelId: allSequenceBreachLevels.first.id,
            ),
          ),
          settingsStateProvider.overrideWith(
            (ref) async => const SettingsState.defaults().copyWith(
              sequenceBreachTutorialSeen: true,
            ),
          ),
        ],
        child: const MemoryHackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Start Mission'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('1. Boot Sequence'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byTooltip('Pause'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Sequence Breach paused'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Restart Level'), findsOneWidget);
    expect(find.text('Quit Mission'), findsOneWidget);
  });
}
