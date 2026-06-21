import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging de red solo en debug, sin headers ni body (evita filtrar tokens/contraseñas).
class SecureLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[HTTP] --> ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP] <-- ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP] <-- ERROR ${err.response?.statusCode ?? '-'} '
        '${err.requestOptions.uri} (${err.type.name})',
      );
    }
    handler.next(err);
  }
}
