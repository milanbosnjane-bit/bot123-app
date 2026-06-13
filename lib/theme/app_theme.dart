import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get cyber {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dialogBackgroundColor: AppColors.card,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.card,
        primary: AppColors.neonBlue,
        secondary: AppColors.neonPurple,
        error: AppColors.neonRed,
        onSurface: AppColors.text,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodySmall: TextStyle(color: AppColors.textMuted, fontSize: 11),
        labelLarge: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  static SystemUiOverlayStyle get systemOverlay => const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      );
}

