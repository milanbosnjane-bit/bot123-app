import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'session_stats_card.dart';
import 'trade_history_card.dart';

/// Trade History (levo) + Session Stats (desno), responsive na uskim ekranima.
class TradeHistorySection extends StatelessWidget {
  const TradeHistorySection({
    super.key,
    required this.trades,
    required this.wins,
    required this.losses,
    required this.lastExit,
    required this.avgProfitUsdt,
  });

  final List<TradeHistoryEntry> trades;
  final int wins;
  final int losses;
  final String lastExit;
  final double avgProfitUsdt;

  static const _breakWidth = 340.0;
  static const _rowHeight = 138.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < _breakWidth;

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TradeHistoryCard(trades: trades),
              const SizedBox(height: 10),
              SessionStatsCard(
                wins: wins,
                losses: losses,
                lastExit: lastExit,
                avgProfitUsdt: avgProfitUsdt,
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Row(
                children: [
                  Expanded(
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'SESSION STATS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _rowHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TradeHistoryCard(
                      trades: trades,
                      showHeader: false,
                      embedded: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SessionStatsCard(
                      wins: wins,
                      losses: losses,
                      lastExit: lastExit,
                      avgProfitUsdt: avgProfitUsdt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
