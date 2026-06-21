import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/oauth_config.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<dynamic>> fetchUsers(String accessToken) async {
    final response = await _client.get(
      Uri.parse('${OAuthConfig.gatewayBaseUrl}/api/users/v1'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception(
      'Error al obtener usuarios (${response.statusCode}): ${response.body}',
    );
  }

  void dispose() {
    _client.close();
  }
}
