import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_panel.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: NeonPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Game Over', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text('Final Score: ${state.score}'),
                Text('High Score: ${state.highScore}'),
                const SizedBox(height: 24),
                NeonButton(
                  label: 'Restart',
                  expanded: true,
                  icon: Icons.replay_rounded,
                  onPressed: () async {
                    await ref.read(gameControllerProvider.notifier).startGame(
                          startLevel: 1,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 12),
                NeonButton(
                  label: 'Exit',
                  expanded: true,
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
