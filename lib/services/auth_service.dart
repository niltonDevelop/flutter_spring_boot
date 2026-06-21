import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/oauth_config.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpirationDateTime,
  });

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? accessTokenExpirationDateTime;
}

class AuthService {
  AuthService({
    http.Client? client,
    FlutterSecureStorage? secureStorage,
  })  : _client = client ?? http.Client(),
        _storage = secureStorage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';

  final http.Client _client;
  final FlutterSecureStorage _storage;

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse(OAuthConfig.nativeLoginEndpoint),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username.trim(),
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Respuesta de login inválida');
      }

      final session = AuthSession(accessToken: accessToken);
      await _persistSession(session);
      return session;
    }

    if (response.statusCode == 401) {
      throw Exception('Usuario o contraseña incorrectos');
    }

    throw Exception('Error de login (${response.statusCode}): ${response.body}');
  }

  Future<AuthSession?> loadSession() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    return AuthSession(accessToken: accessToken);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<void> _persistSession(AuthSession session) async {
    await _storage.write(key: _accessTokenKey, value: session.accessToken);
  }

  void dispose() {
    _client.close();
  }
}
