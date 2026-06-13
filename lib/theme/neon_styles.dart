import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class NeonStyles {
  static List<BoxShadow> glow(
    Color color, {
    double blur = 16,
    double spread = 2,
    double opacity = 0.12,
    bool intense = false,
  }) {
    if (intense) {
      return [
        BoxShadow(
          color: color.withOpacity(opacity * 2.2),
          blurRadius: blur,
          spreadRadius: spread,
        ),
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: blur * 1.8,
          spreadRadius: spread + 2,
        ),
      ];
    }
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  static TextStyle neonText(
    Color color, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    double glowOpacity = 0.55,
    double blur = 12,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      shadows: [
        Shadow(color: color.withOpacity(glowOpacity), blurRadius: blur),
        Shadow(color: color.withOpacity(glowOpacity * 0.6), blurRadius: blur * 2),
        Shadow(color: color.withOpacity(glowOpacity * 0.3), blurRadius: blur * 3),
      ],
    );
  }

  static BoxDecoration cyberCard({
    Color? borderColor,
    Color? glowColor,
    double borderOpacity = 0.3,
    double glowOpacity = 0.12,
    double blurRadius = 16,
    double spreadRadius = 2,
    bool intense = false,
    double borderRadius = 16,
  }) {
    final accent = glowColor ?? borderColor ?? AppColors.cardBorder;
    final effectiveBlur = intense ? 22.0 : blurRadius;
    final effectiveSpread = intense ? 4.0 : spreadRadius;
    final effectiveGlowOpacity = intense ? 0.22 : glowOpacity;
    final effectiveBorderOpacity = intense ? 0.4 : borderOpacity;

    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: accent.withOpacity(effectiveBorderOpacity),
        width: 1.5,
      ),
      boxShadow: glow(
        accent,
        blur: effectiveBlur,
        spread: effectiveSpread,
        opacity: effectiveGlowOpacity,
        intense: intense,
      ),
    );
  }

  /// Glassmorphism pločica za pozicije i istoriju trejdova.
  static BoxDecoration glassTile({Color? accent, double borderRadius = 12}) {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: (accent ?? Colors.white).withOpacity(0.14),
        width: 1,
      ),
    );
  }

  /// Dekoracija za neon dugmad (START / STOP / CLOSE ALL).
  static BoxDecoration neonButton(Color color) {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.65),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.45),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: color.withOpacity(0.18),
          blurRadius: 32,
          spreadRadius: 4,
        ),
      ],
    );
  }

  /// Elegantan tamni dropdown sa plavim neon okvirom.
  static BoxDecoration neonDropdown() {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.neonBlue.withOpacity(0.55),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.neonBlue.withOpacity(0.2),
          blurRadius: 14,
          spreadRadius: 1,
        ),
      ],
    );
  }
}

