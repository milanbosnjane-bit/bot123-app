import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/binance_price_service.dart';
import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import 'glow_card.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({super.key});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  static const _maxPoints = 15;
  static const _pollInterval = Duration(milliseconds: 1500);

  final BinancePriceService _priceService = BinancePriceService();
  final List<double> _prices = [];
  Timer? _timer;
  double? _currentPrice;
  bool _fetchInFlight = false;

  @override
  void initState() {
    super.initState();
    _pollPrice();
    _timer = Timer.periodic(_pollInterval, (_) => _pollPrice());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _priceService.dispose();
    super.dispose();
  }

  Future<void> _pollPrice() async {
    if (_fetchInFlight) return;
    _fetchInFlight = true;
    try {
      final price = await _priceService.fetchBtcPrice();
      if (!mounted || price == null) return;
      setState(() {
        _currentPrice = price;
        _prices.add(price);
        while (_prices.length > _maxPoints) {
          _prices.removeAt(0);
        }
      });
    } finally {
      _fetchInFlight = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = _buildSpots(_prices);
    final bounds = _yBounds(_prices);

    return GlowCard(
      glowColor: Colors.purpleAccent,
      intense: true,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'LIVE GRAFIKON CENE BTC',
                    style: NeonStyles.neonText(
                      Colors.purpleAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      blur: 6,
                      glowOpacity: 0.55,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.show_chart_rounded,
                    size: 12,
                    color: Colors.purpleAccent.withOpacity(0.85),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purpleAccent.withOpacity(0.35)),
                  boxShadow: NeonStyles.glow(
                    Colors.purpleAccent,
                    blur: 10,
                    spread: 0,
                    opacity: 0.12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neonGreen,
                        boxShadow: NeonStyles.glow(AppColors.neonGreen, blur: 6, opacity: 0.5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: NeonStyles.neonText(
                        Colors.purpleAccent,
                        fontSize: 10,
                        blur: 4,
                        glowOpacity: 0.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: spots.length < 2
                ? Center(
                    child: Text(
                      _currentPrice == null
                          ? 'Učitavam cenu BTC...'
                          : 'Prikupljam tačke...',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: bounds.minY,
                      maxY: bounds.maxY,
                      minX: 0,
                      maxX: (_maxPoints - 1).toDouble(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: bounds.interval,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: AppColors.cardBorder.withOpacity(0.6),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 44,
                            interval: bounds.interval,
                            getTitlesWidget: (value, _) => Text(
                              _formatAxisPrice(value),
                              style: const TextStyle(color: AppColors.textDim, fontSize: 9),
                            ),
                          ),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.28,
                          color: AppColors.neonPurple,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, _) => spot == spots.last,
                            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.neonPurple,
                              strokeWidth: 2,
                              strokeColor: AppColors.neonPurple.withOpacity(0.3),
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.neonPurple.withOpacity(0.35),
                                AppColors.neonPurple.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_currentPrice != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.neonPurple.withOpacity(0.4)),
                ),
                child: Text(
                  '\$${_currentPrice!.toStringAsFixed(2)}',
                  style: NeonStyles.neonText(AppColors.neonPurple, fontSize: 10, blur: 6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots(List<double> values) {
    if (values.length < 2) return [];
    final offset = _maxPoints - values.length;
    return List.generate(
      values.length,
      (i) => FlSpot((offset + i).toDouble(), values[i]),
    );
  }

  _YBounds _yBounds(List<double> values) {
    if (values.isEmpty) {
      return const _YBounds(minY: 0, maxY: 1, interval: 0.25);
    }
    var min = values.reduce((a, b) => a < b ? a : b);
    var max = values.reduce((a, b) => a > b ? a : b);
    var range = max - min;
    if (range < 1) {
      final pad = (min * 0.00015).clamp(5.0, 50.0);
      min -= pad;
      max += pad;
      range = max - min;
    } else {
      final pad = range * 0.12;
      min -= pad;
      max += pad;
      range = max - min;
    }
    return _YBounds(
      minY: min,
      maxY: max,
      interval: range / 4,
    );
  }

  String _formatAxisPrice(double value) {
    if (value >= 1000) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }
}

class _YBounds {
  const _YBounds({
    required this.minY,
    required this.maxY,
    required this.interval,
  });

  final double minY;
  final double maxY;
  final double interval;
}
