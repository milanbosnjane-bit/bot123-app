import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import 'glow_card.dart';

class DiagnosticsPanel extends StatelessWidget {
  const DiagnosticsPanel({
    super.key,
    required this.marketState,
    required this.volatilityLabel,
    required this.volatilitySparkline,
    required this.liquidityLabel,
  });

  final String marketState;
  final String volatilityLabel;
  final List<double> volatilitySparkline;
  final String liquidityLabel;

  @override
  Widget build(BuildContext context) {
    final stateShort = _shortMarketState(marketState);
    final spots = _buildSpots(volatilitySparkline);

    return GlowCard(
      glowColor: AppColors.neonBlue,
      intense: true,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DIAGNOSTICS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          const Text('MARKET STATE', style: TextStyle(color: AppColors.textDim, fontSize: 9, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(
            stateShort,
            style: NeonStyles.neonText(AppColors.neonBlue, fontSize: 20, fontWeight: FontWeight.w800, blur: 12),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Volatility', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
              Text(volatilityLabel, style: const TextStyle(color: AppColors.text, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: spots.length < 2
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      minY: 0,
                      maxY: 1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppColors.neonBlue,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Liquidity', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
              Text(
                liquidityLabel,
                style: NeonStyles.neonText(AppColors.neonGreen, fontSize: 12, blur: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortMarketState(String raw) {
    final upper = raw.toUpperCase();
    if (upper.contains('NEUTRAL') || upper.contains('NEDOVOLJAN')) return 'NEUTRAL';
    if (upper.contains('OPEN') || upper.contains('POZICIJA')) return 'ACTIVE';
    if (upper.contains('CHOP') || upper.contains('FLAT')) return 'CHOPPY';
    if (upper.contains('TREND')) return 'TRENDING';
    return 'NEUTRAL';
  }

  List<FlSpot> _buildSpots(List<double> values) {
    if (values.length < 2) return [];
    return List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i]));
  }
}

