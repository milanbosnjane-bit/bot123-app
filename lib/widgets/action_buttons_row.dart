import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({
    super.key,
    this.onStart,
    this.onStop,
    this.onCloseAll,
  });

  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onCloseAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NeonButton(
            label: 'START',
            icon: Icons.play_arrow_rounded,
            color: AppColors.neonBlue,
            onPressed: onStart,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _NeonButton(
            label: 'STOP',
            icon: Icons.stop_rounded,
            color: AppColors.neonPurple,
            onPressed: onStop,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _NeonButton(
            label: 'CLOSE ALL',
            icon: Icons.close_rounded,
            color: AppColors.neonRed,
            onPressed: onCloseAll,
          ),
        ),
      ],
    );
  }
}

class _NeonButton extends StatelessWidget {
  const _NeonButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: NeonStyles.neonButton(color),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
                shadows: [
                  Shadow(color: color.withOpacity(0.7), blurRadius: 12),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(color: color.withOpacity(0.6), blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

