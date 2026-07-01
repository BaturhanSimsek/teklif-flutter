import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/api_paths.dart';
import 'tenant_model.dart';

part 'tenant_repository.g.dart';

@riverpod
TenantRepository tenantRepository(TenantRepositoryRef ref) =>
    TenantRepository(ref.watch(dioProvider));

class TenantRepository {
  TenantRepository(this._dio);
  final Dio _dio;

  Future<TenantSettings> getSettings() async {
    try {
      final res = await _dio.get(ApiPaths.tenantsSettings);
      return TenantSettings.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> updateSettings({
    required String companyLegalName,
    required String city,
    String? phone,
    String? email,
    String? logoUrl,
    String? taxNumber,
    String? taxOffice,
    String? address,
    String? primaryColor,
  }) async {
    try {
      await _dio.put(ApiPaths.tenantsSettings, data: {
        'companyLegalName': companyLegalName,
        'city':             city,
        'phone':            phone,
        'email':            email,
        'logoUrl':          logoUrl,
        'taxNumber':        taxNumber,
        'taxOffice':        taxOffice,
        'address':          address,
        'primaryColor':     primaryColor,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
