/// =============================================================================
/// API BASE URL
/// =============================================================================
///
/// Podrazumevani URL (fallback). Korisnik može promeniti u Settings ekranu
/// bez rebuild-a IPA — čuva se u SharedPreferences.
///
/// Primeri:
///   LAN:       http://192.168.1.101:5000
///   Tailscale: http://100.x.x.x:5000
///   Ngrok:     https://xxxx.ngrok-free.app
///
abstract final class ApiConfig {
  static const String defaultBaseUrl = 'http://100.105.184.37:5000';

  /// Legacy alias — koristi [defaultBaseUrl] ili [ApiUrlStore].
  static const String baseUrl = defaultBaseUrl;

  static String stateUrlFor(String base) => '$base/api/state';
  static String commandUrlFor(String base) => '$base/api/command';
  static String healthUrlFor(String base) => '$base/api/health';

  static const Duration pollInterval = Duration(seconds: 1);

  static const Map<String, String> requestHeaders = {
    'ngrok-skip-browser-warning': 'true',
    'Content-Type': 'application/json',
  };
}
