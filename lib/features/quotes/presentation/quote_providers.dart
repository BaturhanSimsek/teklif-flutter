import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/paged_result.dart';
import '../data/quote_model.dart';
import '../data/quote_repository.dart';

part 'quote_providers.g.dart';

@riverpod
Future<PagedResult<QuoteSummary>> allQuotes(
  AllQuotesRef ref, {
  String? customerId,
  String? search,
  int page = 1,
}) =>
    ref.watch(quoteRepositoryProvider).getAll(
          customerId: customerId,
          search: search,
          page: page,
        );

@riverpod
Future<QuoteDetail> quoteDetail(QuoteDetailRef ref, String quoteId) =>
    ref.watch(quoteRepositoryProvider).getById(quoteId);
