import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/bot_state.dart';
import '../screens/settings_screen.dart';
import '../services/api_url_store.dart';
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
  final ApiUrlStore _urlStore = ApiUrlStore();
  BotApiService? _api;
  BotState _state = BotState.offline();
  final List<double> _volatilityHistory = [];
  Timer? _pollTimer;
  String? _error;
  bool _refreshInFlight = false;
  int _navIndex = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _urlStore.load();
    _api = BotApiService(urlStore: _urlStore);
    if (!mounted) return;
    setState(() => _ready = true);
    _refresh();
    _pollTimer = Timer.periodic(ApiConfig.pollInterval, (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _api?.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_refreshInFlight || _api == null) return;
    _refreshInFlight = true;
    try {
      final next = await _api!.fetchState();
      if (!mounted) return;
      setState(() {
        _state = next;
        _error = null;
        if (next.tickVolatility > 0) {
          _volatilityHistory.add(next.tickVolatility);
          if (_volatilityHistory.length > 12) _volatilityHistory.removeAt(0);
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWithOnline(false);
        _error = '$error\nAPI: ${_urlStore.baseUrl}';
      });
    } finally {
      _refreshInFlight = false;
    }
  }

  Future<void> _sendCommand(String action) async {
    if (_api == null) return;
    try {
      await _api!.sendCommand(action);
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

  Future<void> _applyRisk({
    required double maxDailyLossPct,
    required double riskPerTradePct,
    required double maxDrawdownPct,
    required int leverage,
    required double marginUsdt,
  }) async {
    if (_api == null) return;
    try {
      await _api!.sendRiskSettings(
        maxDailyLossPct: maxDailyLossPct,
        riskPerTradePct: riskPerTradePct,
        maxDrawdownPct: maxDrawdownPct,
        leverage: leverage,
        marginUsdt: marginUsdt,
      );
      await _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Risk update failed: $error'),
          backgroundColor: AppColors.card,
        ),
      );
    }
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

  String _volatilityLabel(BotState state) {
    if (state.volatility != '—') return state.volatility;
    if (state.tickVolatility <= 0) return '—';
    return state.tickVolatility.toStringAsFixed(6);
  }

  List<double> _normalizedSparkline(List<double> raw) {
    if (raw.length < 2) return raw;
    final max = raw.reduce(math.max);
    final min = raw.reduce(math.min);
    final range = max - min;
    if (range == 0) return List.filled(raw.length, 0.5);
    return raw.map((v) => (v - min) / range).toList();
  }

  Widget _buildBody() {
    if (!_ready || _api == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.neonBlue),
      );
    }

    if (_navIndex == 3) {
      return SettingsScreen(
        urlStore: _urlStore,
        api: _api!,
        onUrlSaved: _refresh,
      );
    }

    if (_navIndex != 0) {
      return Center(
        child: Text(
          ['Dashboard', 'Bots', 'Analytics', 'Settings'][_navIndex],
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      );
    }

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

    return SingleChildScrollView(
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
          ChartSection(symbol: _state.symbol, botStateUrl: _urlStore.stateUrl),
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
            maxDailyLossPct: _state.maxDailyLossPct,
            riskPerTradePct: _state.riskPerTradePct,
            maxDrawdownPct: _state.maxDrawdownPct,
            marketState: _state.marketState,
            volatilityLabel: _volatilityLabel(_state),
            volatilitySparkline: _normalizedSparkline(_volatilityHistory),
            liquidityLabel: _liquidityLabel(_state.imbalance),
            onApplyRisk: _applyRisk,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildBody()),
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
