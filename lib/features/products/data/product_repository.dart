import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import 'product_model.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) =>
    ProductRepository(ref.watch(dioProvider));

@riverpod
Future<List<Product>> products(ProductsRef ref) =>
    ref.watch(productRepositoryProvider).getAll();

class ProductRepository {
  ProductRepository(this._dio);
  final Dio _dio;

  Future<List<Product>> getAll({String? search}) async {
    final res = await _dio.get('/products',
        queryParameters: {if (search != null) 'search': search});
    return (res.data as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
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
