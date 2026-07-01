import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
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
    final res = await _dio.get(ApiPaths.users);
    return (res.data as List)
        .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CreateUserResult> create({
    required String fullName,
    required String email,
    required String role,
  }) async {
    final res = await _dio.post(ApiPaths.users, data: {
      'fullName': fullName,
      'email':    email,
      'role':     role,
    });
    return CreateUserResult.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> toggleActive(String userId) async {
    await _dio.patch(ApiPaths.userToggle(userId));
  }

  Future<void> changeRole(String userId, String role) async {
    await _dio.patch(ApiPaths.userRole(userId), data: {'role': role});
  }
}
