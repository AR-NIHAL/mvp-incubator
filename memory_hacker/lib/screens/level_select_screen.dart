import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/level_card.dart';
import 'game_screen.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Level Select')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final level = index + 1;
            return LevelCard(
              level: level,
              unlocked: level <= state.unlockedLevel,
              onTap: () async {
                await ref.read(gameControllerProvider.notifier).startGame(
                      startLevel: level,
                    );
                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
