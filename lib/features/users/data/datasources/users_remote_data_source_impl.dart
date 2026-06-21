import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'users_remote_data_source.dart';

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  const UsersRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get<List<dynamic>>(ApiConfig.usersPath);
      final data = response.data ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(UserModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
