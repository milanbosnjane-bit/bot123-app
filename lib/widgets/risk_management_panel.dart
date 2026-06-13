import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import 'glow_card.dart';

class RiskManagementPanel extends StatefulWidget {
  const RiskManagementPanel({
    super.key,
    required this.leverage,
    required this.marginUsdt,
    required this.onApplyLeverage,
  });

  final int leverage;
  final double marginUsdt;
  final Future<void> Function(int leverage, double marginUsdt) onApplyLeverage;

  @override
  State<RiskManagementPanel> createState() => _RiskManagementPanelState();
}

class _RiskManagementPanelState extends State<RiskManagementPanel> {
  late double _riskPerTrade;
  late double _maxDailyLoss;
  late double _maxDrawdown;
  late int _leverage;

  static const _leverageOptions = [5, 10, 15, 20, 25, 50];

  @override
  void initState() {
    super.initState();
    _riskPerTrade = 1.0;
    _maxDailyLoss = 5.0;
    _maxDrawdown = 10.0;
    _leverage = widget.leverage;
  }

  @override
  void didUpdateWidget(RiskManagementPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leverage != widget.leverage) {
      _leverage = widget.leverage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowColor: AppColors.neonBlue,
      intense: true,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RISK MANAGEMENT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          _CyberSlider(
            label: 'Risk Per Trade',
            value: _riskPerTrade,
            min: 0.5,
            max: 5,
            suffix: '%',
            onChanged: (v) => setState(() => _riskPerTrade = v),
          ),
          _CyberSlider(
            label: 'Max Daily Loss',
            value: _maxDailyLoss,
            min: 1,
            max: 20,
            suffix: '%',
            onChanged: (v) => setState(() => _maxDailyLoss = v),
          ),
          _CyberSlider(
            label: 'Max Drawdown',
            value: _maxDrawdown,
            min: 5,
            max: 30,
            suffix: '%',
            onChanged: (v) => setState(() => _maxDrawdown = v),
          ),
          const SizedBox(height: 6),
          const Text('Leverage', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: NeonStyles.neonDropdown(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: _leverageOptions.contains(_leverage) ? _leverage : _leverageOptions.first,
                dropdownColor: AppColors.card,
                borderRadius: BorderRadius.circular(10),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.neonBlue.withOpacity(0.9),
                  size: 20,
                  shadows: [
                    Shadow(
                      color: AppColors.neonBlue.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                items: _leverageOptions
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          '${v}x',
                          style: TextStyle(
                            color: v == _leverage ? AppColors.neonBlue : AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) async {
                  if (v == null) return;
                  setState(() => _leverage = v);
                  await widget.onApplyLeverage(v, widget.marginUsdt);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowingThumbShape extends SliderComponentShape {
  const _GlowingThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final color = sliderTheme.thumbColor ?? AppColors.neonBlue;
    final canvas = context.canvas;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, 10, glowPaint);

    final thumbPaint = Paint()..color = color;
    canvas.drawCircle(center, 6, thumbPaint);

    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, 6, ringPaint);
  }
}

class _CyberSlider extends StatelessWidget {
  const _CyberSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
              Text(
                '${value.toStringAsFixed(2)}$suffix',
                style: NeonStyles.neonText(AppColors.neonBlue, fontSize: 10, blur: 6, glowOpacity: 0.5),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.neonBlue,
              inactiveTrackColor: AppColors.neonBlue.withOpacity(0.12),
              thumbColor: AppColors.neonBlue,
              overlayColor: AppColors.neonBlue.withOpacity(0.15),
              trackHeight: 2.5,
              trackShape: const RoundedRectSliderTrackShape(),
              thumbShape: const _GlowingThumbShape(),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(value: value, min: min, max: max, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

