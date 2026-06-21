import 'package:dio/dio.dart';

/// Error de red/API con mensaje seguro para la UI (sin filtrar tokens ni cuerpos crudos).
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;

  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return const ApiException(
        'Sesión expirada o credenciales inválidas',
        statusCode: 401,
      );
    }

    if (statusCode == 403) {
      return const ApiException(
        'No tienes permiso para realizar esta acción',
        statusCode: 403,
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        'Tiempo de espera agotado. Verifica tu conexión.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        'No se pudo conectar al servidor. Verifica que el gateway esté activo.',
      );
    }

    final serverMessage = _extractServerMessage(error.response?.data);
    if (serverMessage != null) {
      return ApiException(serverMessage, statusCode: statusCode);
    }

    return ApiException(
      'Error de red${statusCode != null ? ' ($statusCode)' : ''}',
      statusCode: statusCode,
    );
  }

  static String? _extractServerMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'] ?? data['message'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }
    return null;
  }
}
