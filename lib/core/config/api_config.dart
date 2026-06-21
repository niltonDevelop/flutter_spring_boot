import 'dart:io';

/// Punto de entrada único al backend (API Gateway).
///
/// Android emulator: 10.0.2.2 apunta al localhost de la Mac.
/// iOS simulator: 127.0.0.1 funciona directamente.
/// Dispositivo físico: cambia [hostOverride] por la IP de tu Mac (ej. 192.168.1.10).
class ApiConfig {
  ApiConfig._();

  static const String? hostOverride = null;

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

  static String get baseUrl => 'http://$host:$gatewayPort';

  static const String loginPath = '/api/auth/login';
  static const String usersPath = '/api/users/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
