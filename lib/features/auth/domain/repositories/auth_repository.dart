import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';

/// Contrato de repositorio de autenticación (capa de dominio).
abstract interface class AuthRepository {
  Future<Result<bool>> hasSession();

  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<void>> logout();
}
