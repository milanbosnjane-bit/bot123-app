import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/neon_styles.dart';
import 'coin_avatar.dart';
import 'side_badge.dart';

class TradeHistoryEntry {
  const TradeHistoryEntry({
    required this.pair,
    required this.side,
    required this.netPnl,
    required this.duration,
    required this.exitReason,
  });

  final String pair;
  final String side;
  final String netPnl;
  final String duration;
  final String exitReason;
}

class TradeHistoryCard extends StatelessWidget {
  const TradeHistoryCard({
    super.key,
    required this.trades,
    this.showHeader = true,
    this.embedded = false,
  });

  final List<TradeHistoryEntry> trades;
  final bool showHeader;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final list = trades.isEmpty
        ? Center(
            child: Text(
              'No closed trades yet',
              style: TextStyle(
                color: AppColors.textDim.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          )
        : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trades.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) => _HistoryTile(trade: trades[index]),
          );

    if (embedded) {
      return DecoratedBox(
        decoration: NeonStyles.glassTile(borderRadius: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: list,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'TRADE HISTORY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
          ),
        SizedBox(height: 138, child: list),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.trade});

  final TradeHistoryEntry trade;

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.side.toUpperCase() == 'BUY';
    final accent = isBuy ? AppColors.neonGreen : AppColors.neonSell;
    final isProfit = trade.netPnl.contains('+');
    final sideLabel = trade.side.toUpperCase();

    return Container(
      width: 156,
      padding: const EdgeInsets.all(12),
      decoration: NeonStyles.glassTile(accent: accent, borderRadius: 14).copyWith(
        boxShadow: NeonStyles.glow(accent, blur: 16, spread: 1, opacity: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CoinAvatar(symbol: trade.pair, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trade.pair,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SideBadge(label: sideLabel, isLong: isBuy),
          const Spacer(),
          Text(
            trade.netPnl,
            style: NeonStyles.neonText(
              isProfit ? AppColors.profitGlow : AppColors.neonRed,
              fontSize: 13,
              blur: 10,
              glowOpacity: 0.65,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${trade.duration} · ${trade.exitReason}',
            style: const TextStyle(color: AppColors.textDim, fontSize: 9),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

