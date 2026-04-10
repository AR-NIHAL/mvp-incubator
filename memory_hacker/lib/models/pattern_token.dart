import 'package:flutter/material.dart';

/// Different signal types that can appear in a memory sequence.
enum PatternToken {
  red(label: 'A1', color: Color(0xFFFF4D6D), icon: Icons.memory),
  cyan(label: 'C2', color: Color(0xFF00E5FF), icon: Icons.bolt),
  green(label: 'G3', color: Color(0xFF39FF88), icon: Icons.vpn_key),
  amber(label: 'X4', color: Color(0xFFFFC857), icon: Icons.terminal);

  const PatternToken({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}
