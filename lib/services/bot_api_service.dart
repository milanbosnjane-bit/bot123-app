import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/bot_state.dart';
import 'api_url_store.dart';

class BotApiService {
  BotApiService({required ApiUrlStore urlStore, http.Client? client})
      : _urlStore = urlStore,
        _client = client ?? http.Client();

  final ApiUrlStore _urlStore;
  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 10);

  Future<BotState> fetchState() async {
    final url = _urlStore.stateUrl;
    final response = await _client
        .get(Uri.parse(url), headers: ApiConfig.requestHeaders)
        .timeout(
          _timeout,
          onTimeout: () => throw BotApiException(
            'Timeout — nema odgovora sa $url. '
            'Proveri Settings: Tailscale uključen, api_server.py radi.',
          ),
        );

    if (response.statusCode != 200) {
      throw BotApiException('State HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return BotState.fromJson(json);
  }

  /// Vraća true ako je bot_state dostupan.
  Future<bool> checkHealth() async {
    final url = _urlStore.healthUrl;
    final response = await _client
        .get(Uri.parse(url), headers: ApiConfig.requestHeaders)
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw BotApiException('Health HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['bot_state_available'] == true;
  }

  Future<void> sendCommand(
    String action, {
    Map<String, dynamic>? params,
  }) async {
    final body = <String, dynamic>{'action': action, ...?params};

    final response = await _client
        .post(
          Uri.parse(_urlStore.commandUrl),
          headers: ApiConfig.requestHeaders,
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw BotApiException('Command HTTP ${response.statusCode}');
    }
  }

  Future<void> sendSizing({
    required int leverage,
    required double marginUsdt,
  }) async {
    await sendCommand(
      'set_sizing',
      params: {
        'leverage': leverage,
        'margin_usdt': marginUsdt,
      },
    );
  }

  Future<void> sendRiskSettings({
    required double maxDailyLossPct,
    required double riskPerTradePct,
    required double maxDrawdownPct,
    required int leverage,
    required double marginUsdt,
  }) async {
    await sendCommand(
      'set_risk',
      params: {
        'max_daily_loss_pct': maxDailyLossPct,
        'risk_per_trade_pct': riskPerTradePct,
        'max_drawdown_pct': maxDrawdownPct,
        'leverage': leverage,
        'margin_usdt': marginUsdt,
      },
    );
  }

  void dispose() => _client.close();
}

class BotApiException implements Exception {
  BotApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
