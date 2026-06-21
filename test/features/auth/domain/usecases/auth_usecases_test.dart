import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_boot/core/error/result.dart';
import 'package:flutter_spring_boot/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_spring_boot/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/login_params.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/login_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  bool hasSessionValue = false;
  AuthSession? sessionToReturn;

  @override
  Future<Result<bool>> hasSession() async => Success(hasSessionValue);

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    final session = sessionToReturn ?? AuthSession(accessToken: 'token');
    return Success(session);
  }

  @override
  Future<Result<void>> logout() async => const Success(null);
}

void main() {
  group('CheckAuthStatusUseCase', () {
    test('retorna true cuando hay sesión', () async {
      final repository = _FakeAuthRepository()..hasSessionValue = true;
      final useCase = CheckAuthStatusUseCase(repository);

      final result = await useCase();

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });
  });

  group('LoginUseCase', () {
    test('retorna sesión al autenticar', () async {
      final repository = _FakeAuthRepository();
      final useCase = LoginUseCase(repository);

      final result = await useCase(
        const LoginParams(username: 'admin', password: '123'),
      );

      expect(result, isA<Success<AuthSession>>());
    });
  });
}
