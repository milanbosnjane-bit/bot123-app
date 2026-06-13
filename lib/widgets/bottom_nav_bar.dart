import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CyberBottomNav extends StatelessWidget {
  const CyberBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
      (Icons.smart_toy_outlined, Icons.smart_toy_rounded, 'Bots'),
      (Icons.analytics_outlined, Icons.analytics_rounded, 'Analytics'),
      (Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.cardBorder.withOpacity(0.8))),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == currentIndex;
          final color = active ? AppColors.neonBlue : AppColors.navInactive;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(active ? items[i].$2 : items[i].$1, color: color, size: 22),
                const SizedBox(height: 4),
                Text(
                  items[i].$3,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    shadows: active
                        ? [Shadow(color: AppColors.neonBlue.withOpacity(0.5), blurRadius: 8)]
                        : null,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

