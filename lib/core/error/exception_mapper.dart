import 'package:dio/dio.dart';

import '../error/failures.dart';
import '../network/api_exception.dart';

/// Mapea excepciones de infraestructura a [Failure] de dominio.
abstract final class ExceptionMapper {
  static Failure toFailure(Object error) {
    if (error is ApiException) {
      if (error.statusCode == 401) {
        return AuthFailure(error.message, statusCode: error.statusCode);
      }
      if (error.statusCode == 403) {
        return AuthFailure(error.message, statusCode: error.statusCode);
      }
      return ServerFailure(error.message, statusCode: error.statusCode);
    }

    if (error is DioException) {
      return toFailure(ApiException.fromDio(error));
    }

    return UnexpectedFailure(error.toString());
  }
}
