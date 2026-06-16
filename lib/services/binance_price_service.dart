import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class BinancePriceService {
  BinancePriceService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 5);

  Future<double?> fetchPrice(String symbol, {String? stateUrl}) async {
    final binanceSymbol = _toBinanceSymbol(symbol);
    final url =
        'https://api.binance.com/api/v3/ticker/price?symbol=$binanceSymbol';
    try {
      final response = await _client
          .get(Uri.parse(url), headers: ApiConfig.requestHeaders)
          .timeout(_timeout);
      if (response.statusCode != 200) return await _fetchFromBotState(stateUrl);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final price = double.tryParse(json['price'] as String? ?? '');
      return price ?? await _fetchFromBotState(stateUrl);
    } catch (_) {
      return await _fetchFromBotState(stateUrl);
    }
  }

  String _toBinanceSymbol(String symbol) {
    final normalized = symbol.replaceAll('/', '').replaceAll('-', '').toUpperCase();
    if (normalized.isEmpty) return 'BTCUSDT';
    return normalized;
  }

  Future<double?> _fetchFromBotState(String? stateUrl) async {
    final url = stateUrl ?? ApiConfig.stateUrlFor(ApiConfig.defaultBaseUrl);
    try {
      final response = await _client
          .get(Uri.parse(url), headers: ApiConfig.requestHeaders)
          .timeout(_timeout);
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final market = json['market'] as Map<String, dynamic>? ?? {};
      return (market['price'] as num?)?.toDouble();
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();
}
