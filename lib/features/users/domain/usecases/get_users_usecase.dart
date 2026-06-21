import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase implements UseCaseNoParams<Result<List<User>>> {
  const GetUsersUseCase(this._repository);

  final UsersRepository _repository;

  @override
  Future<Result<List<User>>> call() => _repository.getUsers();
}
