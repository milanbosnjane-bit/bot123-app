import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class PnlRow extends StatelessWidget {
  const PnlRow({
    super.key,
    required this.livePnl,
    required this.subtitlePnl,
    required this.winrate,
    required this.isPositive,
  });

  final String livePnl;
  final String subtitlePnl;
  final String winrate;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final pnlAccent = isPositive ? AppColors.profitGlow : AppColors.neonRed;
    const winrateAccent = AppColors.winrateMagenta;

    return Row(
      children: [
        Expanded(
          child: _GlowingMetricCard(
            glowColor: pnlAccent,
            label: 'LIVE PNL',
            value: livePnl,
            subtitle: subtitlePnl,
            accent: pnlAccent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GlowingMetricCard(
            glowColor: winrateAccent,
            label: 'WINRATE',
            value: winrate,
            subtitle: '24H Win Rate',
            accent: winrateAccent,
          ),
        ),
      ],
    );
  }
}

class _GlowingMetricCard extends StatelessWidget {
  const _GlowingMetricCard({
    required this.glowColor,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  final Color glowColor;
  final String label;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: glowColor.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.25),
            blurRadius: 22,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: glowColor.withOpacity(0.12),
            blurRadius: 36,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 12,
                color: AppColors.textDim.withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: NeonStyles.neonText(
              accent,
              fontSize: 22,
              blur: 16,
              glowOpacity: 0.75,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textDim, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

