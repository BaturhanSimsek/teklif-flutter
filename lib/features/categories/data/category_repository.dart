import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_paths.dart';
import 'category_model.dart';

part 'category_repository.g.dart';

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) =>
    CategoryRepository(ref.watch(dioProvider));

@riverpod
Future<List<CategoryModel>> categories(CategoriesRef ref) =>
    ref.watch(categoryRepositoryProvider).getAll();

class CategoryRepository {
  CategoryRepository(this._dio);
  final Dio _dio;

  Future<List<CategoryModel>> getAll() async {
    final res = await _dio.get(ApiPaths.categories);
    final list = res.data as List;
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<String> create({
    required String name,
    String? parentId,
    int sortOrder = 0,
  }) async {
    final res = await _dio.post(ApiPaths.categories, data: {
      'name':      name,
      'parentId':  parentId,
      'sortOrder': sortOrder,
    });
    return res.data['id'] as String;
  }

  Future<void> update({
    required String id,
    required String name,
    String? parentId,
    int sortOrder = 0,
  }) async {
    await _dio.put(ApiPaths.category(id), data: {
      'name':      name,
      'parentId':  parentId,
      'sortOrder': sortOrder,
    });
  }

  Future<void> delete(String id) => _dio.delete(ApiPaths.category(id));
}
