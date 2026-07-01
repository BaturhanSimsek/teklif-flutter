import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_paths.dart';
import 'unit_model.dart';

part 'unit_repository.g.dart';

@riverpod
UnitRepository unitRepository(UnitRepositoryRef ref) =>
    UnitRepository(ref.watch(dioProvider));

@riverpod
Future<List<UnitModel>> units(UnitsRef ref) =>
    ref.watch(unitRepositoryProvider).getAll();

class UnitRepository {
  UnitRepository(this._dio);
  final Dio _dio;

  Future<List<UnitModel>> getAll() async {
    final res = await _dio.get(ApiPaths.units);
    final list = res.data as List;
    return list.map((e) => UnitModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<String> create({
    required String name,
    String symbol = '',
    int sortOrder = 0,
  }) async {
    final res = await _dio.post(ApiPaths.units, data: {
      'name':      name,
      'symbol':    symbol,
      'sortOrder': sortOrder,
    });
    return res.data['id'] as String;
  }

  Future<void> update({
    required String id,
    required String name,
    String symbol = '',
    int sortOrder = 0,
  }) async {
    await _dio.put(ApiPaths.unit(id), data: {
      'name':      name,
      'symbol':    symbol,
      'sortOrder': sortOrder,
    });
  }

  Future<void> delete(String id) => _dio.delete(ApiPaths.unit(id));
}
