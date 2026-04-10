import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../shared/widgets/cyber_panel.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  void _goHome() {
    if (_hasNavigated || !mounted) {
      return;
    }

    _hasNavigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bootstrapState = ref.watch(appBootstrapProvider);
    final theme = Theme.of(context);

    bootstrapState.whenData((_) => _goHome());

    return CyberScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: CyberPanel(
            glowColor: AppColors.accentSecondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'BOOTSTRAP',
                  icon: Icons.memory_rounded,
                  foregroundColor: AppColors.accentSecondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('MEMORY HACKER', style: theme.textTheme.displayMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Initializing shell, persistence, navigation, and interface systems.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: bootstrapState.when(
                    loading: () => const _SplashStatus(
                      key: ValueKey('loading'),
                      label: 'Linking local storage',
                    ),
                    data: (_) => const _SplashStatus(
                      key: ValueKey('ready'),
                      label: 'Handshake complete',
                    ),
                    error: (error, _) => _SplashError(
                      onRetry: () => ref.invalidate(appBootstrapProvider),
                      message: error.toString(),
                    ),
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

class _SplashStatus extends StatelessWidget {
  const _SplashStatus({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}

class _SplashError extends StatelessWidget {
  const _SplashError({required this.onRetry, required this.message});

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('error'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bootstrap failed', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
        ),
      ],
    );
  }
}
