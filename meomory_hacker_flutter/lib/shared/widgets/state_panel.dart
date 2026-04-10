import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'cyber_panel.dart';

class StatePanel extends StatelessWidget {
  const StatePanel({
    required this.title,
    required this.message,
    super.key,
    this.detail,
    this.primaryAction,
    this.secondaryAction,
  });

  final String title;
  final String message;
  final Widget? detail;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: CyberPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (detail != null) ...[
                const SizedBox(height: AppSpacing.sm),
                detail!,
              ],
              if (primaryAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                primaryAction!,
              ],
              if (secondaryAction != null) ...[
                const SizedBox(height: AppSpacing.sm),
                secondaryAction!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
