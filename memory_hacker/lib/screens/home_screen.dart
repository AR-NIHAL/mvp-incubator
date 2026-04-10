import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_panel.dart';
import 'game_screen.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF030712), Color(0xFF0A1A24), Color(0xFF06131D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'MEMORY\nHACKER',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 44,
                        height: 0.94,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trace patterns. Break the sequence. Stay calm under countdown pressure.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 28),
                NeonPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _InfoBlock(label: 'HIGH SCORE', value: '${state.highScore}'),
                          const SizedBox(width: 16),
                          _InfoBlock(label: 'UNLOCKED', value: 'L${state.unlockedLevel}'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: Text(
                          state.message,
                          key: ValueKey(state.message),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                NeonButton(
                  label: 'Play Now',
                  icon: Icons.play_arrow_rounded,
                  expanded: true,
                  onPressed: () async {
                    await ref.read(gameControllerProvider.notifier).startGame();
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                NeonButton(
                  label: 'Level Selection',
                  icon: Icons.grid_view_rounded,
                  expanded: true,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                NeonButton(
                  label: 'Settings',
                  icon: Icons.tune_rounded,
                  expanded: true,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  'Neon memory ops interface',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.accent,
                        letterSpacing: 2,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
