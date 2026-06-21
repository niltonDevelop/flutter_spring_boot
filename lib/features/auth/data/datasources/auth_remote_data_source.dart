import '../../domain/entities/auth_session.dart';

/// Fuente de datos remota de autenticación.
abstract interface class AuthRemoteDataSource {
  Future<AuthSession> login({
    required String username,
    required String password,
  });
}
