import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class BinancePriceService {
  BinancePriceService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _binanceUrl =
      'https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT';
  static const Duration _timeout = Duration(seconds: 5);

  Future<double?> fetchBtcPrice() async {
    try {
      final response = await _client
          .get(Uri.parse(_binanceUrl), headers: ApiConfig.requestHeaders)
          .timeout(_timeout);
      if (response.statusCode != 200) return await _fetchFromBotState();
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final price = double.tryParse(json['price'] as String? ?? '');
      return price ?? await _fetchFromBotState();
    } catch (_) {
      return await _fetchFromBotState();
    }
  }

  Future<double?> _fetchFromBotState() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.stateUrl), headers: ApiConfig.requestHeaders)
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
