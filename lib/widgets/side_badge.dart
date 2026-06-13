import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

/// Neon bedž za LONG/BUY (zeleno) ili SHORT/SELL (crveno-roze).
class SideBadge extends StatelessWidget {
  const SideBadge({
    super.key,
    required this.label,
    required this.isLong,
  });

  final String label;
  final bool isLong;

  @override
  Widget build(BuildContext context) {
    final color = isLong ? AppColors.neonGreen : AppColors.neonSell;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.55)),
        boxShadow: NeonStyles.glow(color, blur: 8, spread: 0, opacity: 0.15),
      ),
      child: Text(
        label,
        style: NeonStyles.neonText(
          color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          blur: 6,
          glowOpacity: 0.5,
        ),
      ),
    );
  }
}

