import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_boot/core/error/result.dart';
import 'package:flutter_spring_boot/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_spring_boot/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_spring_boot/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_spring_boot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_spring_boot/features/auth/presentation/pages/login_page.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<bool>> hasSession() async => const Success(false);

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async =>
      Success(AuthSession(accessToken: 'fake'));

  @override
  Future<Result<void>> logout() async => const Success(null);
}

void main() {
  testWidgets('Muestra pantalla de login', (tester) async {
    final repository = _FakeAuthRepository();
    final authBloc = AuthBloc(
      checkAuthStatus: CheckAuthStatusUseCase(repository),
      login: LoginUseCase(repository),
      logout: LogoutUseCase(repository),
    );
    addTearDown(authBloc.close);

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const MaterialApp(home: LoginPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
