import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import 'coin_avatar.dart';
import 'glow_card.dart';
import 'side_badge.dart';

class OpenPositionsCard extends StatelessWidget {
  const OpenPositionsCard({
    super.key,
    required this.isOpen,
    required this.pair,
    required this.side,
    required this.leverage,
    required this.positionSizeUsdt,
    required this.price,
    required this.livePnl,
    required this.isPositive,
  });

  final bool isOpen;
  final String pair;
  final String side;
  final int leverage;
  final double positionSizeUsdt;
  final double price;
  final String livePnl;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'OPEN POSITIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
        ),
        GlowCard(
          glowColor: isOpen
              ? (side.toUpperCase() == 'BUY' ? AppColors.neonGreen : AppColors.neonSell)
              : Colors.transparent,
          intense: isOpen,
          padding: const EdgeInsets.all(10),
          child: isOpen ? _buildPositionTile() : _buildEmptyTile(),
        ),
      ],
    );
  }

  Widget _buildEmptyTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: NeonStyles.glassTile(),
      child: Row(
        children: [
          CoinAvatar(symbol: pair, size: 36),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'No open positions',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionTile() {
    final isLong = side.toUpperCase() == 'BUY';
    final sideLabel = isLong ? 'LONG' : 'SHORT';
    final accent = isLong ? AppColors.neonGreen : AppColors.neonSell;
    final pnlColor = isPositive ? AppColors.profitGlow : AppColors.neonRed;
    final btcAmount = price > 0 ? positionSizeUsdt / price : 0;
    final coinAccent = CoinAvatar.coinColor(pair);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: NeonStyles.glassTile(accent: accent),
      child: Row(
        children: [
          CoinAvatar(symbol: pair, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pair,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    SideBadge(label: sideLabel, isLong: isLong),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${btcAmount.toStringAsFixed(2)} BTC · ${leverage}x',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'UNREALIZED PNL',
                style: TextStyle(
                  color: AppColors.textDim,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                livePnl,
                style: NeonStyles.neonText(pnlColor, fontSize: 15, blur: 12, glowOpacity: 0.7),
              ),
            ],
          ),
          const SizedBox(width: 2),
          Icon(Icons.chevron_right, color: coinAccent.withOpacity(0.5), size: 20),
        ],
      ),
    );
  }
}

