import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class IconPrefix extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconPrefix({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
