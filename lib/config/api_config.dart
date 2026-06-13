/// =============================================================================
/// API BASE URL — izmeni samo [ApiConfig.baseUrl]
/// =============================================================================
///
/// Ngrok (preporuka — radi sa bilo kog interneta, uključujući iOS):
///   1. Pokreni: ngrok http 5000
///   2. Kopiraj HTTPS "Forwarding" URL, npr. https://a1b2c3d4.ngrok-free.app
///   3. Nalepi ispod BEZ kosih crta na kraju
///
/// Lokalna mreža (zastarelo):
///   static const String baseUrl = 'http://172.20.10.7:5000';
///
abstract final class ApiConfig {
  /// LAN IP laptopa (ista Wi-Fi mreža) ili ngrok URL za daljinski pristup.
  static const String baseUrl = 'http://172.20.10.7:5000';

  // --- Flask API (api_server.py) ---
  static const String stateUrl = '$baseUrl/api/state';
  static const String commandUrl = '$baseUrl/api/command';
  static const String healthUrl = '$baseUrl/api/health';

  /// Alias za dashboard statistiku (isti endpoint kao state).
  static const String stats = stateUrl;

  /// Komande se šalju POST na [commandUrl] sa JSON telom { "action": "..." }.
  /// Ovi stringovi su samo za pregled / dokumentaciju akcija:
  static const String actionStart = 'start';
  static const String actionStop = 'stop';
  static const String actionCloseAll = 'close_all';

  static const Duration pollInterval = Duration(seconds: 1);

  /// Ngrok free tier zahteva ovaj header na svakom zahtevu.
  static const Map<String, String> requestHeaders = {
    'ngrok-skip-browser-warning': 'true',
    'Content-Type': 'application/json',
  };
}

