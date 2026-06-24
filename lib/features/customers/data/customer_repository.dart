import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/paged_result.dart';
import 'customer_model.dart';

part 'customer_repository.g.dart';

@riverpod
CustomerRepository customerRepository(CustomerRepositoryRef ref) =>
    CustomerRepository(ref.watch(dioProvider));

class CustomerRepository {
  CustomerRepository(this._dio);

  final Dio _dio;

  Future<PagedResult<Customer>> getAll({
    String? search,
    int page     = 1,
    int pageSize = 30,
  }) async {
    final res = await _dio.get('/customers', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'pageSize': pageSize,
    });
    return PagedResult.fromJson(
      res.data as Map<String, dynamic>,
      Customer.fromJson,
    );
  }

  Future<String> create({
    required String name,
    required String phone,
    required String email,
    required String address,
    String? taxNumber,
    String? taxOffice,
    String? notes,
  }) async {
    final res = await _dio.post('/customers', data: {
      'name':      name,
      'phone':     phone,
      'email':     email,
      'address':   address,
      'taxNumber': taxNumber,
      'taxOffice': taxOffice,
      'notes':     notes,
    });
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> delete(String id) async {
    await _dio.delete('/customers/$id');
  }

  Future<void> update({
    required String  id,
    required String  name,
    required String  phone,
    required String  email,
    required String  address,
    String? taxNumber,
    String? taxOffice,
    String? notes,
  }) async {
    await _dio.put('/customers/$id', data: {
      'id':        id,
      'name':      name,
      'phone':     phone,
      'email':     email,
      'address':   address,
      'taxNumber': taxNumber,
      'taxOffice': taxOffice,
      'notes':     notes,
    });
  }
}
