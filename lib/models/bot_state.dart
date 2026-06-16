class BotState {
  BotState({
    required this.symbol,
    required this.tick,
    required this.activeStatus,
    required this.currentPosition,
    required this.imbalance,
    required this.signal,
    required this.price,
    required this.tradingEnabled,
    required this.isOnline,
    this.entryPrice,
    this.positionDurationSeconds = 0,
    this.grossUsdt = 0,
    this.grossPct = 0,
    this.winratePct = 0,
    this.dailyPnlUsdt = 0,
    this.leverage = 10,
    this.marginUsdt = 100,
    this.positionSizeUsdt = 1000,
    this.maxDailyLossPct = 10,
    this.riskPerTradePct = 1.8,
    this.maxDrawdownPct = 10,
    this.cooldownSeconds = 15,
    this.marketState = '—',
    this.volatility = '—',
    this.tickVolatility = 0,
    this.topBlocker = '—',
    this.tradeHistory = const [],
    this.sessionWins = 0,
    this.sessionLosses = 0,
    this.closedTrades = 0,
    this.lastExitReason = '—',
    this.avgProfitUsdt = 0,
  });

  final String symbol;
  final int tick;
  final String activeStatus;
  final String currentPosition;
  final double imbalance;
  final String signal;
  final double price;
  final bool tradingEnabled;
  final bool isOnline;
  final double? entryPrice;
  final double positionDurationSeconds;
  final double grossUsdt;
  final double grossPct;
  final double winratePct;
  final double dailyPnlUsdt;
  final int leverage;
  final double marginUsdt;
  final double positionSizeUsdt;
  final double maxDailyLossPct;
  final double riskPerTradePct;
  final double maxDrawdownPct;
  final double cooldownSeconds;
  final String marketState;
  final String volatility;
  final double tickVolatility;
  final String topBlocker;
  final List<TradeHistoryItem> tradeHistory;
  final int sessionWins;
  final int sessionLosses;
  final int closedTrades;
  final String lastExitReason;
  final double avgProfitUsdt;

  bool get isOpen => activeStatus == 'OPEN';

  BotState copyWithOnline(bool online) {
    return BotState(
      symbol: symbol,
      tick: tick,
      activeStatus: activeStatus,
      currentPosition: currentPosition,
      imbalance: imbalance,
      signal: signal,
      price: price,
      tradingEnabled: tradingEnabled,
      isOnline: online,
      entryPrice: entryPrice,
      positionDurationSeconds: positionDurationSeconds,
      grossUsdt: grossUsdt,
      grossPct: grossPct,
      winratePct: winratePct,
      dailyPnlUsdt: dailyPnlUsdt,
      leverage: leverage,
      marginUsdt: marginUsdt,
      positionSizeUsdt: positionSizeUsdt,
      maxDailyLossPct: maxDailyLossPct,
      riskPerTradePct: riskPerTradePct,
      maxDrawdownPct: maxDrawdownPct,
      cooldownSeconds: cooldownSeconds,
      marketState: marketState,
      volatility: volatility,
      tickVolatility: tickVolatility,
      topBlocker: topBlocker,
      tradeHistory: tradeHistory,
      sessionWins: sessionWins,
      sessionLosses: sessionLosses,
      closedTrades: closedTrades,
      lastExitReason: lastExitReason,
      avgProfitUsdt: avgProfitUsdt,
    );
  }

  factory BotState.offline() {
    return BotState(
      symbol: 'BTC/USDT',
      tick: 0,
      activeStatus: 'FLAT',
      currentPosition: 'NONE',
      imbalance: 0,
      signal: 'NONE',
      price: 0,
      tradingEnabled: false,
      isOnline: false,
    );
  }

  factory BotState.fromJson(Map<String, dynamic> json) {
    final config = json['config'] as Map<String, dynamic>? ?? {};
    final market = json['market'] as Map<String, dynamic>? ?? {};
    final session = json['session'] as Map<String, dynamic>? ?? {};
    final control = json['control'] as Map<String, dynamic>? ?? {};
    final block = json['block_diagnostics'] as Map<String, dynamic>? ?? {};
    final filters = json['filters'] as Map<String, dynamic>? ?? {};

    final unrealized = market['unrealized_pnl'] as Map<String, dynamic>?;
    final positionSize =
        (config['position_size_usdt'] as num?)?.toDouble() ?? 1000;
    final grossUsdt = (unrealized?['gross_usdt'] as num?)?.toDouble() ?? 0;
    final grossPct =
        positionSize > 0 ? (grossUsdt / positionSize) * 100 : 0.0;

    final trades = _parseTradeHistory(json);

    final closedTrades = (session['closed_trades'] as num?)?.toInt() ?? 0;
    final dailyPnl = (session['daily_pnl_usdt'] as num?)?.toDouble() ?? 0;
    final avgPnl = (session['avg_pnl_usdt'] as num?)?.toDouble() ??
        (closedTrades > 0 ? dailyPnl / closedTrades : 0.0);
    final lastExit = trades.isNotEmpty
        ? trades.first.exitReason
        : '—';

    return BotState(
      symbol: config['symbol'] as String? ?? 'BTC/USDT',
      tick: (market['tick'] as num?)?.toInt() ?? 0,
      activeStatus: market['active_status'] as String? ?? 'FLAT',
      currentPosition: market['current_position'] as String? ?? 'NONE',
      imbalance: (market['imbalance'] as num?)?.toDouble() ?? 0,
      signal: market['signal'] as String? ?? 'NONE',
      price: (market['price'] as num?)?.toDouble() ?? 0,
      tradingEnabled: control['trading_enabled'] as bool? ?? true,
      isOnline: true,
      entryPrice: (market['entry_price'] as num?)?.toDouble(),
      positionDurationSeconds:
          (market['position_duration_seconds'] as num?)?.toDouble() ?? 0,
      grossUsdt: grossUsdt,
      grossPct: grossPct,
      winratePct: (session['winrate_pct'] as num?)?.toDouble() ?? 0,
      dailyPnlUsdt: dailyPnl,
      leverage: (control['leverage'] as num?)?.toInt() ??
          (config['leverage'] as num?)?.toInt() ??
          10,
      marginUsdt: (control['margin_usdt'] as num?)?.toDouble() ??
          (config['margin_usdt'] as num?)?.toDouble() ??
          100,
      positionSizeUsdt: (control['position_size_usdt'] as num?)?.toDouble() ??
          (config['position_size_usdt'] as num?)?.toDouble() ??
          1000,
      maxDailyLossPct: (control['max_daily_loss_pct'] as num?)?.toDouble() ?? 10,
      riskPerTradePct: (control['risk_per_trade_pct'] as num?)?.toDouble() ?? 1.8,
      maxDrawdownPct: (control['max_drawdown_pct'] as num?)?.toDouble() ?? 10,
      cooldownSeconds: 15,
      marketState: block['summary'] as String? ?? '—',
      volatility: _topFilterRate(filters, 'VOLATILITY'),
      tickVolatility: (market['tick_volatility'] as num?)?.toDouble() ?? 0,
      topBlocker: block['top_filter'] as String? ?? '—',
      tradeHistory: trades,
      sessionWins: (session['wins'] as num?)?.toInt() ?? 0,
      sessionLosses: (session['losses'] as num?)?.toInt() ?? 0,
      closedTrades: closedTrades,
      lastExitReason: lastExit.isEmpty ? '—' : lastExit,
      avgProfitUsdt: avgPnl,
    );
  }

  static List<TradeHistoryItem> _parseTradeHistory(Map<String, dynamic> json) {
    final recent = json['recent_trades'] as List<dynamic>?;
    if (recent != null && recent.isNotEmpty) {
      return recent
          .whereType<Map<String, dynamic>>()
          .map(TradeHistoryItem.fromJson)
          .toList();
    }
    final lastTrade = json['last_closed_trade'] as Map<String, dynamic>?;
    if (lastTrade != null && lastTrade.isNotEmpty) {
      return [TradeHistoryItem.fromJson(lastTrade)];
    }
    return const [];
  }

  static String _topFilterRate(Map<String, dynamic> filters, String key) {
    final entry = filters[key] as Map<String, dynamic>?;
    if (entry == null) return '—';
    final rate = (entry['rate'] as num?)?.toDouble();
    if (rate == null) return '—';
    return '${(rate * 100).toStringAsFixed(0)}% block';
  }
}

class TradeHistoryItem {
  TradeHistoryItem({
    required this.side,
    required this.exitReason,
    required this.netPnl,
    required this.duration,
  });

  final String side;
  final String exitReason;
  final String netPnl;
  final String duration;

  factory TradeHistoryItem.fromJson(Map<String, dynamic> json) {
    final net = (json['net_pnl_usdt'] as num?)?.toDouble() ?? 0;
    final durationSec = (json['duration_seconds'] as num?)?.toDouble() ?? 0;
    final side = json['position_side'] as String? ?? '—';
    return TradeHistoryItem(
      side: side,
      exitReason: json['exit_reason'] as String? ?? '—',
      netPnl: '${net >= 0 ? '+' : ''}${net.toStringAsFixed(2)} USDT',
      duration: '${durationSec.toStringAsFixed(0)}s',
    );
  }
}
