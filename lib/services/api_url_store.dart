import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

/// Čuva API base URL na telefonu — ne mora rebuild IPA kad se IP promeni.
class ApiUrlStore extends ChangeNotifier {
  ApiUrlStore();

  static const _prefsKey = 'api_base_url';

  String _baseUrl = ApiConfig.defaultBaseUrl;
  bool _loaded = false;

  String get baseUrl => _baseUrl;
  bool get isLoaded => _loaded;

  String get stateUrl => ApiConfig.stateUrlFor(_baseUrl);
  String get commandUrl => ApiConfig.commandUrlFor(_baseUrl);
  String get healthUrl => ApiConfig.healthUrlFor(_baseUrl);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && saved.trim().isNotEmpty) {
      _baseUrl = normalizeUrl(saved);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> save(String raw) async {
    _baseUrl = normalizeUrl(raw);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _baseUrl);
    notifyListeners();
  }

  Future<void> resetToDefault() => save(ApiConfig.defaultBaseUrl);

  static String normalizeUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) return ApiConfig.defaultBaseUrl;
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    return url;
  }
}
