import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memory_hacker_flutter/data/local/local_storage_providers.dart';
import 'package:memory_hacker_flutter/features/results/presentation/results_screen.dart';
import 'package:memory_hacker_flutter/game/models/sequence_breach_progression_state.dart';
import 'package:memory_hacker_flutter/game/providers/sequence_breach_level_catalog.dart';

void main() {
  testWidgets('invalid result mission id shows a safe fallback state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressionStateProvider.overrideWith(
            (ref) async => SequenceBreachProgressionState.initial(
              firstLevelId: allSequenceBreachLevels.first.id,
            ),
          ),
        ],
        child: const MaterialApp(home: ResultsScreen(levelId: 'invalid-node')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mission result unavailable'), findsOneWidget);
    expect(find.text('Back To Mission Grid'), findsOneWidget);
  });

  testWidgets('valid mission without saved result shows launch prompt', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressionStateProvider.overrideWith(
            (ref) async => SequenceBreachProgressionState.initial(
              firstLevelId: allSequenceBreachLevels.first.id,
            ),
          ),
        ],
        child: const MaterialApp(home: ResultsScreen(levelId: 'boot-sequence')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No run recorded yet'), findsOneWidget);
    expect(find.text('Launch Mission'), findsOneWidget);
  });
}
