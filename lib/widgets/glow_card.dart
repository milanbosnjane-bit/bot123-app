import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = Colors.transparent,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.intense = false,
  });

  final Widget child;
  final Color glowColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool intense;

  @override
  Widget build(BuildContext context) {
    final hasGlow = glowColor != Colors.transparent;

    return Container(
      margin: margin,
      padding: padding,
      decoration: NeonStyles.cyberCard(
        glowColor: hasGlow ? glowColor : null,
        borderColor: hasGlow ? glowColor : AppColors.cardBorder,
        intense: intense,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

