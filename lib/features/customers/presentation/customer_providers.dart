import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/paged_result.dart';
import '../data/customer_model.dart';
import '../data/customer_repository.dart';

part 'customer_providers.g.dart';

@riverpod
Future<PagedResult<Customer>> customers(
  CustomersRef ref, {
  String? search,
  int page = 1,
}) =>
    ref.watch(customerRepositoryProvider).getAll(
          search: search,
          page: page,
        );
