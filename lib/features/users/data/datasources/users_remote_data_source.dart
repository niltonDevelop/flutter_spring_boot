import '../../domain/entities/user.dart';

/// Fuente de datos remota de usuarios.
abstract interface class UsersRemoteDataSource {
  Future<List<User>> getUsers();
}
