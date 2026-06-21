import 'package:bloc/bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_params.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CheckAuthStatusUseCase checkAuthStatus,
    required LoginUseCase login,
    required LogoutUseCase logout,
  })  : _checkAuthStatus = checkAuthStatus,
        _login = login,
        _logout = logout,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final CheckAuthStatusUseCase _checkAuthStatus;
  final LoginUseCase _login;
  final LogoutUseCase _logout;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _checkAuthStatus();
    switch (result) {
      case Success(:final data):
        emit(
          AuthState(
            status: data
                ? AuthStatus.authenticated
                : AuthStatus.unauthenticated,
          ),
        );
      case Error(:final failure):
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _login(
      LoginParams(username: event.username, password: event.password),
    );

    switch (result) {
      case Success():
        emit(const AuthState(status: AuthStatus.authenticated));
      case Error(:final failure):
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: _loginFailureMessage(failure),
          ),
        );
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Tu sesión expiró. Inicia sesión nuevamente.',
      ),
    );
  }

  String _loginFailureMessage(Failure failure) {
    if (failure is AuthFailure && failure.statusCode == 401) {
      return 'Usuario o contraseña incorrectos';
    }
    return failure.message;
  }
}
