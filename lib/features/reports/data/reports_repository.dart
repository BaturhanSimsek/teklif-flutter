import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import 'reports_model.dart';

part 'reports_repository.g.dart';

@riverpod
ReportsRepository reportsRepository(ReportsRepositoryRef ref) =>
    ReportsRepository(ref.watch(dioProvider));

class ReportsRepository {
  ReportsRepository(this._dio);
  final Dio _dio;

  Future<ReportsData> get() async {
    try {
      final res = await _dio.get('/reports');
      return ReportsData.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
