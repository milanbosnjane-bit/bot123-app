import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({
    super.key,
    required this.isOnline,
    required this.tradingEnabled,
  });

  final bool isOnline;
  final bool tradingEnabled;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = widget.isOnline && widget.tradingEnabled;
    final paused = widget.isOnline && !widget.tradingEnabled;
    final statusColor = !widget.isOnline
        ? AppColors.neonRed
        : paused
            ? Colors.orange
            : AppColors.neonGreen;
    final statusLabel = !widget.isOnline
        ? 'OFFLINE'
        : paused
            ? 'PAUSED'
            : 'RUNNING';

    return Row(
      children: [
        const Text(
          'AI TRADING BOT',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.neonPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.neonPurple.withOpacity(0.5)),
          ),
          child: Text(
            '[PRO]',
            style: NeonStyles.neonText(
              AppColors.neonPurple,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              blur: 6,
            ),
          ),
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final glow = running ? 0.3 + _pulse.value * 0.4 : 0.12;
            final dotOpacity = running ? 0.45 + _pulse.value * 0.55 : 0.7;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0D14),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: statusColor.withOpacity(running ? 0.75 : 0.45),
                  width: 1.2,
                ),
                boxShadow: NeonStyles.glow(
                  statusColor,
                  blur: running ? 18 : 10,
                  spread: running ? 2 : 0,
                  opacity: glow,
                  intense: running,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: dotOpacity,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        boxShadow: NeonStyles.glow(
                          statusColor,
                          blur: 10,
                          spread: 1,
                          opacity: 0.9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: NeonStyles.neonText(
                      statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      blur: running ? 8 + _pulse.value * 4 : 4,
                      glowOpacity: 0.65,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

