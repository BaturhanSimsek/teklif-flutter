import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../constants/api_paths.dart';

part 'device_token_repository.g.dart';

@riverpod
DeviceTokenRepository deviceTokenRepository(DeviceTokenRepositoryRef ref) =>
    DeviceTokenRepository(ref.watch(dioProvider));

class DeviceTokenRepository {
  DeviceTokenRepository(this._dio);

  final Dio _dio;

  Future<void> updateDeviceToken(String token) async {
    try {
      await _dio.put(ApiPaths.profileDevToken, data: {'token': token});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> removeDeviceToken() async {
    try {
      await _dio.put(ApiPaths.profileDevToken, data: {'token': null});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
