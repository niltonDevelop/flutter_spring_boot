import '../../../../core/error/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements UseCaseNoParams<Result<bool>> {
  const CheckAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<bool>> call() => _repository.hasSession();
}
