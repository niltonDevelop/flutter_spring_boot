import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../models/auth_token_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConfig.loginPath,
        data: {
          'username': username.trim(),
          'password': password,
        },
      );

      return AuthTokenModel.fromJson(response.data ?? const {}).toEntity();
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const ApiException(
          'Usuario o contraseña incorrectos',
          statusCode: 401,
        );
      }
      throw ApiException.fromDio(error);
    }
  }
}
