import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/datasources/auth_local_data_source_impl.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/network/auth_interceptor.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/users/data/datasources/users_remote_data_source_impl.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/usecases/get_users_usecase.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../router/auth_refresh_listenable.dart';

/// Composition root: ensambla dependencias respetando Clean Architecture.
class InjectionContainer {
  InjectionContainer._({
    required this.authBloc,
    required this.usersBloc,
    required this.router,
    required this.refreshListenable,
    required this.dio,
  });

  final AuthBloc authBloc;
  final UsersBloc usersBloc;
  final GoRouter router;
  final AuthRefreshListenable refreshListenable;
  final Dio dio;

  factory InjectionContainer.create() {
    final authLocalDataSource = AuthLocalDataSourceImpl();
    AuthBloc? authBlocRef;

    final dio = DioClient.create(
      interceptors: [
        AuthInterceptor(
          localDataSource: authLocalDataSource,
          onSessionExpired: () =>
              authBlocRef?.add(const AuthSessionExpired()),
        ),
      ],
    );

    final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    final checkAuthStatus = CheckAuthStatusUseCase(authRepository);
    final login = LoginUseCase(authRepository);
    final logout = LogoutUseCase(authRepository);

    final authBloc = AuthBloc(
      checkAuthStatus: checkAuthStatus,
      login: login,
      logout: logout,
    );
    authBlocRef = authBloc;

    final usersRemoteDataSource = UsersRemoteDataSourceImpl(dio: dio);
    final usersRepository = UsersRepositoryImpl(
      remoteDataSource: usersRemoteDataSource,
    );
    final getUsers = GetUsersUseCase(usersRepository);

    final usersBloc = UsersBloc(getUsers: getUsers);

    final refreshListenable = AuthRefreshListenable(authBloc);
    final router = AppRouter.create(
      refreshListenable: refreshListenable,
      readAuthState: () => authBloc.state,
    );

    authBloc.add(const AuthCheckRequested());

    return InjectionContainer._(
      authBloc: authBloc,
      usersBloc: usersBloc,
      router: router,
      refreshListenable: refreshListenable,
      dio: dio,
    );
  }

  void dispose() {
    refreshListenable.dispose();
    authBloc.close();
    usersBloc.close();
    dio.close(force: true);
  }
}
