import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/api/api_client.dart';
import '../../../core/cache/local_cache.dart';
import '../../../core/models/paged_result.dart';
import '../../../core/offline/outbox_entry.dart';
import '../../../core/offline/outbox_repository.dart';
import 'customer_model.dart';

part 'customer_repository.g.dart';

const _cuuid = Uuid();

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
    final cacheKey = 'cache:customers:$search:$page:$pageSize';
    try {
      final res = await _dio.get('/customers', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'pageSize': pageSize,
      });
      final result = PagedResult.fromJson(
        res.data as Map<String, dynamic>,
        Customer.fromJson,
      );
      await LocalCache.set(cacheKey, res.data);
      return result;
    } on DioException {
      final cached = await LocalCache.get<PagedResult<Customer>>(
        cacheKey,
        (j) => PagedResult.fromJson(j as Map<String, dynamic>, Customer.fromJson),
      );
      if (cached != null) return cached;
      rethrow;
    }
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
    final payload = {
      'name': name, 'phone': phone, 'email': email, 'address': address,
      'taxNumber': taxNumber, 'taxOffice': taxOffice, 'notes': notes,
    };

    final results = await Connectivity().checkConnectivity();
    final online  = results.any((r) => r != ConnectivityResult.none);

    if (online) {
      final ik  = _cuuid.v4();
      final res = await _dio.post('/customers', data: payload,
          options: Options(headers: {'X-Idempotency-Key': ik}));
      return (res.data as Map<String, dynamic>)['id'] as String;
    }

    final tempId = 'temp_${_cuuid.v4()}';
    await OutboxRepository().add(OutboxEntry(
      id             : _cuuid.v4(),
      entityType     : OutboxEntityType.customer,
      operation      : OutboxOperation.create,
      payload        : jsonEncode({...payload, '_tempId': tempId}),
      idempotencyKey : _cuuid.v4(),
      createdAt      : DateTime.now(),
    ));
    return tempId;
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
