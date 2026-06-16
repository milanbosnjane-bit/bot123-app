import 'package:flutter/material.dart';

import 'diagnostics_panel.dart';
import 'risk_management_panel.dart';

class BottomPanelsRow extends StatelessWidget {
  const BottomPanelsRow({
    super.key,
    required this.leverage,
    required this.marginUsdt,
    required this.maxDailyLossPct,
    required this.riskPerTradePct,
    required this.maxDrawdownPct,
    required this.marketState,
    required this.volatilityLabel,
    required this.volatilitySparkline,
    required this.liquidityLabel,
    required this.onApplyRisk,
  });

  final int leverage;
  final double marginUsdt;
  final double maxDailyLossPct;
  final double riskPerTradePct;
  final double maxDrawdownPct;
  final String marketState;
  final String volatilityLabel;
  final List<double> volatilitySparkline;
  final String liquidityLabel;
  final Future<void> Function({
    required double maxDailyLossPct,
    required double riskPerTradePct,
    required double maxDrawdownPct,
    required int leverage,
    required double marginUsdt,
  }) onApplyRisk;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RiskManagementPanel(
            leverage: leverage,
            marginUsdt: marginUsdt,
            maxDailyLossPct: maxDailyLossPct,
            riskPerTradePct: riskPerTradePct,
            maxDrawdownPct: maxDrawdownPct,
            onApplyRisk: onApplyRisk,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DiagnosticsPanel(
            marketState: marketState,
            volatilityLabel: volatilityLabel,
            volatilitySparkline: volatilitySparkline,
            liquidityLabel: liquidityLabel,
          ),
        ),
      ],
    );
  }
}
