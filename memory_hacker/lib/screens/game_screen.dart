import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_status.dart';
import '../providers/game_controller.dart';
import '../widgets/hud_panel.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_panel.dart';
import '../widgets/pattern_tile_widget.dart';
import 'game_over_screen.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(gameControllerProvider, (previous, next) {
      if (next.status == GameStatus.gameOver &&
          previous?.status != GameStatus.gameOver &&
          context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GameOverScreen()),
        );
      }
    });

    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Hacker'),
        actions: [
          IconButton(
            onPressed: () => ref.read(gameControllerProvider.notifier).replayLevel(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Replay current level',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF163248), Color(0xFF07111A)],
            center: Alignment.topCenter,
            radius: 1.2,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                HudPanel(
                  level: state.level,
                  score: state.score,
                  lives: state.lives,
                  timeLeft: state.timeRemaining,
                ),
                const SizedBox(height: 18),
                NeonPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Sequence Feed',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              state.status.name.toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RepaintBoundary(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(state.sequence.length, (index) {
                            final token = state.sequence[index];
                            final visible = state.status == GameStatus.previewing &&
                                state.activePreviewIndex == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: visible
                                    ? token.color.withValues(alpha: 0.9)
                                    : Colors.white.withValues(alpha: 0.05),
                                border: Border.all(
                                  color: visible
                                      ? token.color
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                                boxShadow: visible
                                    ? [
                                        BoxShadow(
                                          color: token.color.withValues(alpha: 0.35),
                                          blurRadius: 18,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                visible ? token.icon : Icons.question_mark_rounded,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          state.message,
                          key: ValueKey(state.message),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: RepaintBoundary(
                    child: GridView.builder(
                      itemCount: state.availableTokens.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final token = state.availableTokens[index];
                        final isPreviewMatch = state.status == GameStatus.previewing &&
                            state.activePreviewIndex >= 0 &&
                            state.sequence[state.activePreviewIndex] == token;

                        return PatternTileWidget(
                          token: token,
                          isActive: isPreviewMatch,
                          enabled: state.canInteract,
                          onTap: () => ref
                              .read(gameControllerProvider.notifier)
                              .selectToken(token),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                NeonButton(
                  label: state.canInteract ? 'Awaiting Input' : 'Sequence Locked',
                  icon:
                      state.canInteract ? Icons.touch_app_rounded : Icons.visibility_rounded,
                  expanded: true,
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
