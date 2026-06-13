import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class SessionStatsCard extends StatelessWidget {
  const SessionStatsCard({
    super.key,
    required this.wins,
    required this.losses,
    required this.lastExit,
    required this.avgProfitUsdt,
  });

  final int wins;
  final int losses;
  final String lastExit;
  final double avgProfitUsdt;

  @override
  Widget build(BuildContext context) {
    final avgPositive = avgProfitUsdt >= 0;
    final avgText = '${avgPositive ? '+' : ''}${avgProfitUsdt.toStringAsFixed(2)} USDT';

    return Container(
      height: 138,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: NeonStyles.glow(
          Colors.purpleAccent,
          blur: 20,
          spread: 2,
          opacity: 0.18,
          intense: true,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_outlined, size: 14, color: Colors.purpleAccent.withOpacity(0.9)),
              const SizedBox(width: 5),
              Text(
                'SESSION STATS',
                style: NeonStyles.neonText(
                  Colors.purpleAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  blur: 6,
                  glowOpacity: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _StatLine(
            icon: Icons.check_circle_outline,
            text: '$wins Wins',
            color: AppColors.neonGreen,
          ),
          const SizedBox(height: 5),
          _StatLine(
            icon: Icons.cancel_outlined,
            text: '$losses Losses',
            color: AppColors.neonRed,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.logout_rounded, size: 13, color: AppColors.neonBlue.withOpacity(0.85)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Last Exit: $lastExit',
                  style: NeonStyles.neonText(
                    AppColors.neonBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    blur: 5,
                    glowOpacity: 0.45,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 13, color: AppColors.profitGlow.withOpacity(0.9)),
              const SizedBox(width: 4),
              Text(
                'Avg: $avgText',
                style: NeonStyles.neonText(
                  avgPositive ? AppColors.profitGlow : AppColors.neonRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  blur: 8,
                  glowOpacity: 0.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color.withOpacity(0.9)),
        const SizedBox(width: 5),
        Text(
          '• $text',
          style: NeonStyles.neonText(
            color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            blur: 6,
            glowOpacity: 0.5,
          ),
        ),
      ],
    );
  }
}
