import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import 'login_params.dart';

class LoginUseCase implements UseCase<Result<AuthSession>, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AuthSession>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }
}
