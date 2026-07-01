import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/api/api_client.dart';
import '../../../core/cache/local_cache.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/paged_result.dart';
import '../../../core/offline/outbox_entry.dart';
import '../../../core/offline/outbox_repository.dart';
import 'ai_quote_suggestion.dart';
import 'kanban_model.dart';
import 'quote_model.dart';

part 'quote_repository.g.dart';

const _uuid = Uuid();

@riverpod
QuoteRepository quoteRepository(QuoteRepositoryRef ref) =>
    QuoteRepository(ref.watch(dioProvider));

// Internet baglantisi var mi?
Future<bool> _isOnline() async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}

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
      final res = await _dio.get(ApiPaths.quotes, queryParameters: {
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
      final res  = await _dio.get(ApiPaths.quoteByCustomer(customerId));
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
      final res    = await _dio.get(ApiPaths.quoteById(quoteId));
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
    if (await _isOnline()) {
      // Online: direkt sunucuya gonder
      final idempotencyKey = _uuid.v4();
      final res = await _dio.post(ApiPaths.quotes, data: payload,
          options: Options(headers: {'X-Idempotency-Key': idempotencyKey}));
      return (res.data as Map<String, dynamic>)['id'] as String;
    }

    // Offline: gecici bir ID ile outbox'a ekle, sync edilince sunucunun ID'si kullanilir
    final tempId = 'temp_${_uuid.v4()}';
    await OutboxRepository().add(OutboxEntry(
      id             : _uuid.v4(),
      entityType     : OutboxEntityType.quote,
      operation      : OutboxOperation.create,
      payload        : jsonEncode({...payload, '_tempId': tempId}),
      idempotencyKey : _uuid.v4(),
      createdAt      : DateTime.now(),
    ));
    return tempId; // uygulama gecici ID ile calisir, sync sonrasi guncellenir
  }

  Future<void> approve(String quoteId, {bool approve = true}) async {
    await _dio.patch(ApiPaths.quoteApprove(quoteId), queryParameters: {'approve': approve});
    await LocalCache.clear('$_cacheKeyDetail$quoteId');
  }

  Future<void> send(String quoteId) async {
    if (await _isOnline()) {
      final idempotencyKey = _uuid.v4();
      await _dio.post(ApiPaths.quoteSend(quoteId),
          options: Options(headers: {'X-Idempotency-Key': idempotencyKey}));
      await LocalCache.clear('$_cacheKeyDetail$quoteId');
      return;
    }

    // Offline: outbox'a ekle — internet gelince WhatsApp gonderimi tetiklenecek
    await OutboxRepository().add(OutboxEntry(
      id             : _uuid.v4(),
      entityType     : OutboxEntityType.quote,
      operation      : OutboxOperation.send,
      payload        : jsonEncode({'id': quoteId}),
      idempotencyKey : _uuid.v4(),
      createdAt      : DateTime.now(),
    ));
  }

  Future<String> revise(String quoteId) async {
    final res = await _dio.post(ApiPaths.quoteRevise(quoteId));
    return (res.data as Map<String, dynamic>)['id'] as String;
  }

  Future<void> cancel(String quoteId) async {
    await _dio.delete(ApiPaths.quoteById(quoteId));
    await LocalCache.clear('$_cacheKeyDetail$quoteId');
  }

  Future<List<QuoteSummary>> getRevisions(String quoteId) async {
    final res = await _dio.get(ApiPaths.quoteRevisions(quoteId));
    return (res.data as List)
        .map((j) => QuoteSummary.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<String> generateShareLink(String quoteId) async {
    final res = await _dio.post(ApiPaths.quoteShareLink(quoteId));
    return (res.data as Map<String, dynamic>)['url'] as String;
  }

  Future<List<AiQuoteItemSuggestion>> aiGenerate(String prompt) async {
    final res = await _dio.post(ApiPaths.quotesAiGenerate, data: {'prompt': prompt});
    return (res.data as List)
        .map((j) => AiQuoteItemSuggestion.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<KanbanBoard> getKanban() async {
    final res = await _dio.get(ApiPaths.quotesKanban);
    return KanbanBoard.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> moveStage(String quoteId, String stage) async {
    await _dio.patch(ApiPaths.quoteStage(quoteId), data: {'stage': stage});
  }
}
