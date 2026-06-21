import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/users/presentation/pages/home_page.dart';
import 'app_routes.dart';
import 'auth_refresh_listenable.dart';

abstract final class AppRouter {
  static GoRouter create({
    required AuthRefreshListenable refreshListenable,
    required AuthState Function() readAuthState,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: refreshListenable,
      debugLogDiagnostics: kDebugMode,
      redirect: (context, state) =>
          _redirect(readAuthState(), state.matchedLocation),
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri.path}'),
        ),
      ),
    );
  }

  static String? _redirect(AuthState auth, String path) {
    final isSplash = path == AppRoutes.splash;
    final isLogin = path == AppRoutes.login;
    final isHome = path == AppRoutes.home;

    switch (auth.status) {
      case AuthStatus.unknown:
      case AuthStatus.loading:
        return isSplash ? null : AppRoutes.splash;
      case AuthStatus.authenticated:
        if (isSplash || isLogin) return AppRoutes.home;
        return null;
      case AuthStatus.unauthenticated:
        if (isHome) return AppRoutes.login;
        if (isSplash) return AppRoutes.login;
        return isLogin ? null : AppRoutes.login;
    }
  }
}
