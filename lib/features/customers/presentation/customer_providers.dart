import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/customer_model.dart';
import '../data/customer_repository.dart';

part 'customer_providers.g.dart';

@riverpod
Future<List<Customer>> customers(CustomersRef ref, {String? search}) =>
    ref.watch(customerRepositoryProvider).getAll(search: search);
