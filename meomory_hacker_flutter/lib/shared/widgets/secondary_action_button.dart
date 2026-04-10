import 'package:flutter/material.dart';

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.tune_rounded),
      label: Text(label),
    );
  }
}
