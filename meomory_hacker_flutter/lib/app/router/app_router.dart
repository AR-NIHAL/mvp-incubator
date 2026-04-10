import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/gameplay/presentation/gameplay_shell_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/level_select/presentation/level_select_screen.dart';
import '../../features/results/presentation/results_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../game/models/sequence_breach_result.dart';
import '../../shared/widgets/state_panel.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) {
      return const _RouteErrorScreen();
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.levels,
        builder: (context, state) => const LevelSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.results}/:levelId',
        builder: (context, state) {
          final levelId = state.pathParameters['levelId'] ?? '';
          return ResultsScreen(
            levelId: levelId,
            latestResult: state.extra is SequenceBreachResult
                ? state.extra as SequenceBreachResult
                : null,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.play}/:levelId',
        builder: (context, state) {
          final levelId = state.pathParameters['levelId'] ?? '';
          return GameplayShellScreen(levelId: levelId);
        },
      ),
    ],
  );
});

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: StatePanel(
          title: 'Route not found',
          message:
              'The requested screen is unavailable. Return to the mission grid to continue.',
          primaryAction: FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Back To Home'),
          ),
        ),
      ),
    );
  }
}
