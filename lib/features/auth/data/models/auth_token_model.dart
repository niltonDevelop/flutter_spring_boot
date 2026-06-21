import '../../domain/entities/auth_session.dart';

class AuthTokenModel {
  const AuthTokenModel({required this.accessToken});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final token = json['accessToken'] as String?;
    if (token == null || token.isEmpty) {
      throw const FormatException('Respuesta de login inválida');
    }
    return AuthTokenModel(accessToken: token);
  }

  final String accessToken;

  AuthSession toEntity() => AuthSession(accessToken: accessToken);
}
