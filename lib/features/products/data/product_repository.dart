import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/paged_result.dart';
import 'product_model.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) =>
    ProductRepository(ref.watch(dioProvider));

@riverpod
Future<PagedResult<Product>> products(ProductsRef ref) =>
    ref.watch(productRepositoryProvider).getAll();

class ProductRepository {
  ProductRepository(this._dio);
  final Dio _dio;

  Future<PagedResult<Product>> getAll({
    String? search,
    int page     = 1,
    int pageSize = 30,
  }) async {
    final res = await _dio.get('/products', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'pageSize': pageSize,
    });
    return PagedResult.fromJson(
      res.data as Map<String, dynamic>,
      Product.fromJson,
    );
  }

  Future<String> create({
    required String  name,
    required String  unit,
    required double  salePrice,
    required double  purchasePrice,
    String?          categoryId,
    String?          notes,
  }) async {
    final res = await _dio.post('/products', data: {
      'name':          name,
      'unit':          unit,
      'salePrice':     salePrice,
      'purchasePrice': purchasePrice,
      'categoryId':    categoryId,
      'notes':         notes,
      'photoUrl':      null,
    });
    return res.data['id'] as String;
  }

  Future<void> update({
    required String  id,
    required String  name,
    required String  unit,
    required double  salePrice,
    required double  purchasePrice,
    String?          categoryId,
    String?          notes,
  }) async {
    await _dio.put('/products/$id', data: {
      'name':          name,
      'unit':          unit,
      'salePrice':     salePrice,
      'purchasePrice': purchasePrice,
      'categoryId':    categoryId,
      'notes':         notes,
      'photoUrl':      null,
    });
  }

  Future<void> delete(String id) => _dio.delete('/products/$id');
}
