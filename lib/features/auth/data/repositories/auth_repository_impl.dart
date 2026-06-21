import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<bool>> hasSession() async {
    try {
      final hasSession = await _localDataSource.hasSession();
      return Success(hasSession);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      await _localDataSource.writeAccessToken(session.accessToken);
      return Success(session);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localDataSource.clearSession();
      return const Success(null);
    } catch (error) {
      return Error(CacheFailure(error.toString()));
    }
  }
}
