import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import 'tenant_model.dart';

part 'tenant_repository.g.dart';

@riverpod
TenantRepository tenantRepository(TenantRepositoryRef ref) =>
    TenantRepository(ref.watch(dioProvider));

class TenantRepository {
  TenantRepository(this._dio);
  final Dio _dio;

  Future<TenantSettings> getSettings() async {
    final res = await _dio.get('/tenants/settings');
    return TenantSettings.fromJson(res.data as Map<String, dynamic>);
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
    await _dio.put('/tenants/settings', data: {
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
  }
}
