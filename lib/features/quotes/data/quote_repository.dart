import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/cache/local_cache.dart';
import '../../../core/models/paged_result.dart';
import 'quote_model.dart';

part 'quote_repository.g.dart';

@riverpod
QuoteRepository quoteRepository(QuoteRepositoryRef ref) =>
    QuoteRepository(ref.watch(dioProvider));

class QuoteRepository {
  QuoteRepository(this._dio);

  final Dio _dio;

  static const _cacheKeyList   = 'cache:quotes:list';
  static const _cacheKeyDetail = 'cache:quotes:detail:';

  Future<PagedResult<QuoteSummary>> getAll({
    String? customerId,
    String? search,
    int page     = 1,
    int pageSize = 20,
  }) async {
    final cacheKey = '$_cacheKeyList:$customerId:$search:$page:$pageSize';
    try {
      final res = await _dio.get('/quotes', queryParameters: {
        if (customerId != null) 'customerId': customerId,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'pageSize': pageSize,
      });
      final result = PagedResult.fromJson(
        res.data as Map<String, dynamic>,
        QuoteSummary.fromJson,
      );
      await LocalCache.set(cacheKey, res.data);
      return result;
    } on DioException {
      final cached = await LocalCache.get<PagedResult<QuoteSummary>>(
        cacheKey,
        (j) => PagedResult.fromJson(j as Map<String, dynamic>, QuoteSummary.fromJson),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<List<QuoteSummary>> getByCustomer(String customerId) async {
    final cacheKey = 'cache:quotes:by-customer:$customerId';
    try {
      final res  = await _dio.get('/quotes/by-customer/$customerId');
      final list = res.data as List<dynamic>;
      final result = list.map((e) => QuoteSummary.fromJson(e as Map<String, dynamic>)).toList();
      await LocalCache.set(cacheKey, res.data);
      return result;
    } on DioException {
      final cached = await LocalCache.get<List<QuoteSummary>>(
        cacheKey,
        (j) => (j as List).map((e) => QuoteSummary.fromJson(e as Map<String, dynamic>)).toList(),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<QuoteDetail> getById(String quoteId) async {
    final cacheKey = '$_cacheKeyDetail$quoteId';
    try {
      final res    = await _dio.get('/quotes/$quoteId');
      final result = QuoteDetail.fromJson(res.data as Map<String, dynamic>);
      await LocalCache.set(cacheKey, res.data);
      return result;
    } on DioException {
      final cached = await LocalCache.get<QuoteDetail>(
        cacheKey,
        (j) => QuoteDetail.fromJson(j as Map<String, dynamic>),
      );
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<String> create(Map<String, dynamic> payload) async {
    final res = await _dio.post('/quotes', data: payload);
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> approve(String quoteId, {bool approve = true}) async {
    await _dio.patch('/quotes/$quoteId/approve', queryParameters: {'approve': approve});
    await LocalCache.clear('$_cacheKeyDetail$quoteId');
  }

  Future<String> revise(String quoteId) async {
    final res = await _dio.post('/quotes/$quoteId/revise');
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> cancel(String quoteId) async {
    await _dio.delete('/quotes/$quoteId');
    await LocalCache.clear('$_cacheKeyDetail$quoteId');
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
