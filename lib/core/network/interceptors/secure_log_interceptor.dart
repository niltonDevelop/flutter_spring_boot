import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging de red solo en debug. Incluye headers con valores sensibles enmascarados.
class SecureLogInterceptor extends Interceptor {
  static const _sensitiveHeaders = {'authorization', 'cookie', 'set-cookie'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[HTTP] --> ${options.method} ${options.uri}');
      debugPrint('[HTTP] headers: ${_safeHeaders(options.headers)}');
    }
    handler.next(options);
  }

  static Map<String, dynamic> _safeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (_sensitiveHeaders.contains(key.toLowerCase())) {
        return MapEntry(key, 'Bearer eyJra***');
      }
      return MapEntry(key, value);
    });
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
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
