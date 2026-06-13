import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class CoinAvatar extends StatelessWidget {
  const CoinAvatar({super.key, required this.symbol, this.size = 40});

  final String symbol;
  final double size;

  static Color coinColor(String symbol) {
    final letter = symbol.isNotEmpty ? symbol[0].toUpperCase() : '?';
    return switch (letter) {
      'B' => const Color(0xFFF7931A),
      'E' => const Color(0xFF627EEA),
      'S' => const Color(0xFF14F195),
      _ => AppColors.neonBlue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final letter = symbol.isNotEmpty ? symbol[0].toUpperCase() : '?';
    final bg = coinColor(symbol);

    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size + 6,
            height: size + 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: NeonStyles.glow(bg, blur: 14, spread: 2, opacity: 0.35),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  bg.withOpacity(0.35),
                  bg.withOpacity(0.12),
                ],
              ),
              border: Border.all(color: bg.withOpacity(0.7), width: 1.2),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: bg,
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.42,
                  shadows: [
                    Shadow(color: bg.withOpacity(0.6), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

