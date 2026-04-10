import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../game/models/settings_state.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/cyber_panel.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/status_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStateProvider);

    return CyberScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: AppIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      child: settingsAsync.when(
        data: (settings) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                const SectionTitle(
                  title: 'Tune the interface',
                  subtitle:
                      'These shell settings persist locally and already feed onboarding, accessibility, and presentation behavior across the MVP shell.',
                  badge: StatusBadge(
                    label: 'LOCAL SETTINGS',
                    icon: Icons.tune_rounded,
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                CyberPanel(
                  child: Column(
                    children: [
                      _SettingSwitchTile(
                        title: 'Sound',
                        subtitle:
                            'Keep navigation and future gameplay audio enabled.',
                        value: settings.soundOn,
                        onChanged: (value) => _saveSettings(
                          ref,
                          settings.copyWith(soundOn: value),
                        ),
                      ),
                      const Divider(),
                      _SettingSwitchTile(
                        title: 'Haptics',
                        subtitle:
                            'Reinforce key taps, failures, and results beats.',
                        value: settings.hapticsOn,
                        onChanged: (value) => _saveSettings(
                          ref,
                          settings.copyWith(hapticsOn: value),
                        ),
                      ),
                      const Divider(),
                      _SettingSwitchTile(
                        title: 'Reduced Motion',
                        subtitle:
                            'Trim transitions and glow-heavy movement where possible.',
                        value: settings.reducedMotion,
                        onChanged: (value) => _saveSettings(
                          ref,
                          settings.copyWith(reducedMotion: value),
                        ),
                      ),
                      const Divider(),
                      _SettingSwitchTile(
                        title: 'High Contrast',
                        subtitle:
                            'Increase separation across panels, labels, and states.',
                        value: settings.highContrast,
                        onChanged: (value) => _saveSettings(
                          ref,
                          settings.copyWith(highContrast: value),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CyberPanel(
                  glowColor: AppColors.accentSecondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Build notes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Settings persist through Hive using a single repository path shared by the shell and gameplay presentation layer.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings(WidgetRef ref, SettingsState nextState) async {
    await ref.read(settingsRepositoryProvider).saveSettings(nextState);
    ref.invalidate(settingsStateProvider);
  }
}

class _SettingSwitchTile extends StatelessWidget {
  const _SettingSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
