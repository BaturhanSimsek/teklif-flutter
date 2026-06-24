import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import 'dashboard_model.dart';

part 'dashboard_repository.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) =>
    DashboardRepository(ref.watch(dioProvider));

class DashboardRepository {
  DashboardRepository(this._dio);
  final Dio _dio;

  Future<DashboardData> get() async {
    final res = await _dio.get('/dashboard');
    return DashboardData.fromJson(res.data as Map<String, dynamic>);
  }
}
