import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  const UsersRepositoryImpl({required UsersRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Success(users);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }
}
