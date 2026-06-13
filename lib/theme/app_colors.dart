import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Ekstremno tamna crno-plava — pozadina celog ekrana.
  static const Color background = Color(0xFF05070A);

  /// Ultra tamna unutrašnjost kartica.
  static const Color card = Color(0xFF0F121C);

  static const Color cardBorder = Color(0xFF1A2235);

  static const Color neonGreen = Color(0xFF0CF087);
  static const Color profitGlow = Color(0xFF00FFCC);
  static const Color winrateMagenta = Color(0xFFE040FB);
  static const Color neonPurple = Color(0xFFAF52DE);
  static const Color neonBlue = Color(0xFF00B0FF);
  static const Color neonRed = Color(0xFFFF3B30);
  static const Color neonSell = Color(0xFFFF2D55);

  // Legacy aliases
  static const Color green = neonGreen;
  static const Color purple = neonPurple;
  static const Color blue = neonBlue;
  static const Color red = neonRed;

  static const Color text = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDim = Color(0xFF4B5563);

  static const Color navInactive = Color(0xFF5C6370);
}

