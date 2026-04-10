import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memory_hacker_flutter/features/gameplay/presentation/gameplay_shell_screen.dart';

void main() {
  testWidgets('invalid mission id shows a safe fallback state', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: GameplayShellScreen(levelId: 'invalid-node')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mission unavailable'), findsOneWidget);
    expect(
      find.text(
        'This mission id is invalid or no longer exists in the current catalog.',
      ),
      findsOneWidget,
    );
    expect(find.text('Back To Mission Grid'), findsOneWidget);
  });
}
