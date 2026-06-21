import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_config.dart';
import '../datasources/auth_local_data_source.dart';

/// Interceptor HTTP de autenticación (capa de datos del feature auth).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AuthLocalDataSource localDataSource,
    VoidCallback? onSessionExpired,
  })  : _localDataSource = localDataSource,
        _onSessionExpired = onSessionExpired;

  final AuthLocalDataSource _localDataSource;
  final VoidCallback? _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == ApiConfig.loginPath) {
      handler.next(options);
      return;
    }

    final token = await _localDataSource.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiConfig.loginPath) {
      await _localDataSource.clearSession();
      _onSessionExpired?.call();
    }
    handler.next(err);
  }
}
