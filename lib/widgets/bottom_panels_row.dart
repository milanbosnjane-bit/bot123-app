import 'package:flutter/material.dart';

import 'diagnostics_panel.dart';
import 'risk_management_panel.dart';

class BottomPanelsRow extends StatelessWidget {
  const BottomPanelsRow({
    super.key,
    required this.leverage,
    required this.marginUsdt,
    required this.marketState,
    required this.volatilityLabel,
    required this.volatilitySparkline,
    required this.liquidityLabel,
    required this.onApplyLeverage,
  });

  final int leverage;
  final double marginUsdt;
  final String marketState;
  final String volatilityLabel;
  final List<double> volatilitySparkline;
  final String liquidityLabel;
  final Future<void> Function(int leverage, double marginUsdt) onApplyLeverage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RiskManagementPanel(
            leverage: leverage,
            marginUsdt: marginUsdt,
            onApplyLeverage: onApplyLeverage,
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

