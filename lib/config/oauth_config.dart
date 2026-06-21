import 'dart:io';

/// URLs del backend Spring Cloud (OAuth + Gateway).
///
/// Android emulator: 10.0.2.2 apunta al localhost de la Mac.
/// iOS simulator: 127.0.0.1 funciona directamente.
/// Dispositivo físico: cambia [hostOverride] por la IP de tu Mac (ej. 192.168.1.10).
class OAuthConfig {
  OAuthConfig._();

  static const String? hostOverride = null;

  static const String clientId = 'flutter-app';
  static const String redirectUri = 'com.ngonzano.app://oauth/callback';
  static const List<String> scopes = ['openid', 'profile'];

  static const int oauthPort = 9190;
  static const int gatewayPort = 8080;

  static String get host {
    if (hostOverride != null && hostOverride!.isNotEmpty) {
      return hostOverride!;
    }
    if (Platform.isAndroid) {
      return '10.0.2.2';
    }
    return '127.0.0.1';
  }

  static String get oauthBaseUrl => 'http://$host:$oauthPort';

  static String get gatewayBaseUrl => 'http://$host:$gatewayPort';

  static String get nativeLoginEndpoint => '$oauthBaseUrl/api/auth/login';
}
