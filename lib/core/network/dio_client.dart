import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_config.dart';
import 'interceptors/secure_log_interceptor.dart';

/// Factory del cliente HTTP compartido (infraestructura core).
abstract final class DioClient {
  static Dio create({required List<Interceptor> interceptors}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.addAll([
      ...interceptors,
      if (kDebugMode) SecureLogInterceptor(),
    ]);

    return dio;
  }
}
