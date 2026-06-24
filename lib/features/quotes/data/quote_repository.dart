import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/paged_result.dart';
import 'quote_model.dart';

part 'quote_repository.g.dart';

@riverpod
QuoteRepository quoteRepository(QuoteRepositoryRef ref) =>
    QuoteRepository(ref.watch(dioProvider));

class QuoteRepository {
  QuoteRepository(this._dio);

  final Dio _dio;

  Future<PagedResult<QuoteSummary>> getAll({
    String? customerId,
    String? search,
    int page     = 1,
    int pageSize = 20,
  }) async {
    final res = await _dio.get('/quotes', queryParameters: {
      if (customerId != null) 'customerId': customerId,
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
      'pageSize': pageSize,
    });
    return PagedResult.fromJson(
      res.data as Map<String, dynamic>,
      QuoteSummary.fromJson,
    );
  }

  Future<List<QuoteSummary>> getByCustomer(String customerId) async {
    final res = await _dio.get('/quotes/by-customer/$customerId');
    final list = res.data as List<dynamic>;
    return list.map((e) => QuoteSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<QuoteDetail> getById(String quoteId) async {
    final res = await _dio.get('/quotes/$quoteId');
    return QuoteDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<String> create(Map<String, dynamic> payload) async {
    final res = await _dio.post('/quotes', data: payload);
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> approve(String quoteId, {bool approve = true}) async {
    await _dio.patch('/quotes/$quoteId/approve', queryParameters: {'approve': approve});
  }

  Future<String> revise(String quoteId) async {
    final res = await _dio.post('/quotes/$quoteId/revise');
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> cancel(String quoteId) async {
    await _dio.delete('/quotes/$quoteId');
  }

  Future<List<QuoteSummary>> getRevisions(String quoteId) async {
    final res = await _dio.get('/quotes/$quoteId/revisions');
    return (res.data as List)
        .map((j) => QuoteSummary.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<String> generateShareLink(String quoteId) async {
    final res = await _dio.post('/quotes/$quoteId/share-link');
    return (res.data as Map<String, dynamic>)['url'] as String;
  }
}
