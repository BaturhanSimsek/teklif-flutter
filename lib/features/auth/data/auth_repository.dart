import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_model.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(ref.watch(dioProvider));

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  Future<LoginResponse> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final response = LoginResponse.fromJson(res.data as Map<String, dynamic>);

    await _storage.write(key: AppConstants.tokenKey,        value: response.accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: response.refreshToken);
    await _storage.write(key: AppConstants.tenantIdKey,     value: response.tenantId);
    await _storage.write(key: AppConstants.userEmailKey,    value: response.email);
    await _storage.write(key: AppConstants.userRoleKey,           value: response.role);
    await _storage.write(key: AppConstants.userIdKey,             value: response.userId);
    await _storage.write(key: AppConstants.mustChangePasswordKey, value: response.mustChangePassword.toString());

    return response;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}
