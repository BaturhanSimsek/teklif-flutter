import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import 'user_model.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepository(ref.watch(dioProvider));

class UserRepository {
  UserRepository(this._dio);
  final Dio _dio;

  Future<List<AppUser>> getAll() async {
    try {
      final res = await _dio.get(ApiPaths.users);
      return (res.data as List)
          .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<CreateUserResult> create({
    required String fullName,
    required String email,
    required String role,
  }) async {
    try {
      final res = await _dio.post(ApiPaths.users, data: {
        'fullName': fullName,
        'email':    email,
        'role':     role,
      });
      return CreateUserResult.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> toggleActive(String userId) async {
    try {
      await _dio.patch(ApiPaths.userToggle(userId));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> changeRole(String userId, String role) async {
    try {
      await _dio.patch(ApiPaths.userRole(userId), data: {'role': role});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
