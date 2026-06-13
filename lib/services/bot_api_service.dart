import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/bot_state.dart';

class BotApiService {
  BotApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 10);

  Future<BotState> fetchState() async {
    final response = await _client
        .get(
          Uri.parse(ApiConfig.stateUrl),
          headers: ApiConfig.requestHeaders,
        )
        .timeout(
          _timeout,
          onTimeout: () => throw BotApiException(
            'Timeout — nema odgovora sa ${ApiConfig.stateUrl}. '
            'Proveri: ngrok tunel aktivan, api_server.py radi, baseUrl u api_config.dart.',
          ),
        );

    if (response.statusCode != 200) {
      throw BotApiException('State HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return BotState.fromJson(json);
  }

  Future<void> sendCommand(
    String action, {
    Map<String, dynamic>? params,
  }) async {
    final body = <String, dynamic>{'action': action, ...?params};

    final response = await _client
        .post(
          Uri.parse(ApiConfig.commandUrl),
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

  void dispose() => _client.close();
}

class BotApiException implements Exception {
  BotApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

