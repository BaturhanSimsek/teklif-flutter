import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/quote_model.dart';
import '../data/quote_repository.dart';

part 'quote_providers.g.dart';

@riverpod
Future<List<QuoteSummary>> quotesByCustomer(QuotesByCustomerRef ref, String customerId) =>
    ref.watch(quoteRepositoryProvider).getByCustomer(customerId);

@riverpod
Future<QuoteDetail> quoteDetail(QuoteDetailRef ref, String quoteId) =>
    ref.watch(quoteRepositoryProvider).getById(quoteId);
