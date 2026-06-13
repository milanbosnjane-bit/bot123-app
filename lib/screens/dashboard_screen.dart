import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/bot_state.dart';
import '../services/bot_api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/action_buttons_row.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/bottom_panels_row.dart';
import '../widgets/chart_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/open_positions_card.dart';
import '../widgets/pnl_row.dart';
import '../widgets/trade_history_card.dart';
import '../widgets/trade_history_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BotApiService _api = BotApiService();
  BotState _state = BotState.offline();
  final List<double> _volatilityHistory = [];
  Timer? _pollTimer;
  String? _error;
  bool _refreshInFlight = false;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
    _pollTimer = Timer.periodic(ApiConfig.pollInterval, (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _api.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_refreshInFlight) return;
    _refreshInFlight = true;
    try {
      final next = await _api.fetchState();
      if (!mounted) return;
      setState(() {
        _state = next;
        _error = null;
        final vol = next.imbalance.abs();
        _volatilityHistory.add(vol);
        if (_volatilityHistory.length > 12) _volatilityHistory.removeAt(0);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWithOnline(false);
        _error = '$error\nAPI: ${ApiConfig.baseUrl}';
      });
    } finally {
      _refreshInFlight = false;
    }
  }

  Future<void> _sendCommand(String action) async {
    try {
      await _api.sendCommand(action);
      await _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Command failed: $error'),
          backgroundColor: AppColors.card,
        ),
      );
    }
  }

  Future<void> _applySizing(int leverage, double marginUsdt) async {
    await _api.sendSizing(leverage: leverage, marginUsdt: marginUsdt);
    await _refresh();
  }

  String _formatUsdt(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)} USDT';
  }

  String _liquidityLabel(double imbalance) {
    final abs = imbalance.abs();
    if (abs >= 0.7) return 'High';
    if (abs >= 0.4) return 'Medium';
    return 'Low';
  }

  String _volatilityPercent(List<double> history) {
    if (history.length < 2) return '—';
    final avg = history.reduce((a, b) => a + b) / history.length;
    return '${(avg * 100).toStringAsFixed(1)}%';
  }

  List<double> _normalizedSparkline(List<double> raw) {
    if (raw.length < 2) return raw;
    final max = raw.reduce(math.max);
    final min = raw.reduce(math.min);
    final range = max - min;
    if (range == 0) return List.filled(raw.length, 0.5);
    return raw.map((v) => (v - min) / range).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = _state.isOpen;
    final displayPnl = isOpen ? _state.grossUsdt : _state.dailyPnlUsdt;
    final isPositive = displayPnl >= 0;

    final trades = _state.tradeHistory
        .map(
          (t) => TradeHistoryEntry(
            pair: _state.symbol,
            side: t.side,
            netPnl: t.netPnl,
            duration: t.duration,
            exitReason: t.exitReason,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
            Expanded(
              child: _navIndex == 0
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DashboardHeader(
                            isOnline: _state.isOnline,
                            tradingEnabled: _state.tradingEnabled,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(_error!, style: const TextStyle(color: AppColors.neonRed, fontSize: 10)),
                          ],
                          const SizedBox(height: 18),
                          PnlRow(
                            livePnl: _formatUsdt(displayPnl),
                            subtitlePnl: isOpen ? 'Unrealized PnL' : "Today's Profit",
                            winrate: '${_state.winratePct.toStringAsFixed(0)}%',
                            isPositive: isPositive,
                          ),
                          const SizedBox(height: 14),
                          const ChartSection(),
                          const SizedBox(height: 14),
                          OpenPositionsCard(
                            isOpen: isOpen,
                            pair: _state.symbol,
                            side: _state.currentPosition,
                            leverage: _state.leverage,
                            positionSizeUsdt: _state.positionSizeUsdt,
                            price: _state.price,
                            livePnl: isOpen ? _formatUsdt(_state.grossUsdt) : '0.00 USDT',
                            isPositive: _state.grossUsdt >= 0,
                          ),
                          const SizedBox(height: 16),
                          TradeHistorySection(
                            trades: trades,
                            wins: _state.sessionWins,
                            losses: _state.sessionLosses,
                            lastExit: _state.lastExitReason,
                            avgProfitUsdt: _state.avgProfitUsdt,
                          ),
                          const SizedBox(height: 18),
                          ActionButtonsRow(
                            onStart: () => _sendCommand('start'),
                            onStop: () => _sendCommand('stop'),
                            onCloseAll: () => _sendCommand('close_all'),
                          ),
                          const SizedBox(height: 14),
                          BottomPanelsRow(
                            leverage: _state.leverage,
                            marginUsdt: _state.marginUsdt,
                            marketState: _state.marketState,
                            volatilityLabel: _volatilityPercent(_volatilityHistory),
                            volatilitySparkline: _normalizedSparkline(_volatilityHistory),
                            liquidityLabel: _liquidityLabel(_state.imbalance),
                            onApplyLeverage: _applySizing,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        ['Dashboard', 'Bots', 'Analytics', 'Settings'][_navIndex],
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ),
            ),
              CyberBottomNav(
                currentIndex: _navIndex,
                onTap: (i) => setState(() => _navIndex = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

