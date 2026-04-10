import 'package:flutter/material.dart';

import '../models/pattern_token.dart';

class PatternTileWidget extends StatelessWidget {
  const PatternTileWidget({
    super.key,
    required this.token,
    required this.isActive,
    required this.onTap,
    required this.enabled,
  });

  final PatternToken token;
  final bool isActive;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: isActive ? 1.04 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              token.color.withValues(alpha: isActive ? 0.95 : 0.45),
              token.color.withValues(alpha: isActive ? 0.55 : 0.16),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: token.color.withValues(alpha: enabled ? 0.9 : 0.25),
            width: isActive ? 2.2 : 1.4,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: token.color.withValues(alpha: 0.38),
                    blurRadius: 26,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(token.icon, size: 32, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    token.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
