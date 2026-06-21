import '../../../../core/error/result.dart';
import '../entities/user.dart';

/// Contrato de repositorio de usuarios (capa de dominio).
abstract interface class UsersRepository {
  Future<Result<List<User>>> getUsers();
}
