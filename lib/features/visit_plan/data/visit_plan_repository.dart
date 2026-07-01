import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import 'visit_plan_model.dart';

part 'visit_plan_repository.g.dart';

@riverpod
VisitPlanRepository visitPlanRepository(VisitPlanRepositoryRef ref) =>
    VisitPlanRepository(ref.watch(dioProvider));

class VisitPlanRepository {
  VisitPlanRepository(this._dio);
  final Dio _dio;

  Future<List<VisitPlan>> getPlans({String? date, String? userId}) async {
    try {
      final res = await _dio.get(ApiPaths.visitPlans, queryParameters: {
        if (date != null) 'date': date,
        if (userId != null) 'userId': userId,
      });
      return (res.data as List).map((e) => VisitPlan.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> create({
    required String customerId,
    required DateTime plannedAt,
    String? notes,
    String? assignedUserId,
  }) async {
    try {
      await _dio.post(ApiPaths.visitPlans, data: {
        'customerId': customerId,
        'plannedAt':  plannedAt.toIso8601String(),
        if (notes != null)          'notes':          notes,
        if (assignedUserId != null) 'assignedUserId': assignedUserId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> updateStatus(String id, int status, {String? outcome}) async {
    try {
      await _dio.patch(ApiPaths.visitPlanStatus(id), data: {
        'id': id,
        'status': status,
        if (outcome != null) 'outcome': outcome,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@riverpod
Future<List<VisitPlan>> todayVisitPlans(TodayVisitPlansRef ref) {
  final today = DateTime.now();
  final date = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  return ref.watch(visitPlanRepositoryProvider).getPlans(date: date);
}
