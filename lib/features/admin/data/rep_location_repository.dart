import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import 'rep_location_model.dart';

final repLocationRepositoryProvider = Provider((ref) =>
    RepLocationRepository(ref.watch(dioProvider)));

class RepLocationRepository {
  const RepLocationRepository(this._dio);
  final Dio _dio;

  Future<List<RepLocation>> getAll() async {
    try {
      final res = await _dio.get<List>(ApiPaths.userLocations);
      return (res.data ?? [])
          .map((e) => RepLocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
