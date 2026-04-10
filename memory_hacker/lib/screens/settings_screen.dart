import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/neon_panel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: NeonPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile.adaptive(
                title: const Text('Sound Effects'),
                subtitle: const Text('Keeps the placeholder sound hooks enabled.'),
                value: state.soundEnabled,
                onChanged: (value) async {
                  await ref.read(gameControllerProvider.notifier).updateSound(value);
                },
              ),
              const Divider(),
              SwitchListTile.adaptive(
                title: const Text('Vibration Feedback'),
                subtitle: const Text('Adds haptics for taps and mistakes where supported.'),
                value: state.vibrationEnabled,
                onChanged: (value) async {
                  await ref.read(gameControllerProvider.notifier).updateVibration(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
