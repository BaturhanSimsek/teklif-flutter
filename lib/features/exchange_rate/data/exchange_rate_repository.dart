import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';

part 'exchange_rate_repository.g.dart';

@riverpod
ExchangeRateRepository exchangeRateRepository(ExchangeRateRepositoryRef ref) =>
    ExchangeRateRepository(ref.watch(dioProvider));

class ExchangeRateRepository {
  ExchangeRateRepository(this._dio);
  final Dio _dio;

  Future<Map<String, double>> getRates({bool force = false}) async {
    try {
      final res = await _dio.get(
        '/exchange-rate',
        queryParameters: force ? {'force': true} : null,
      );
      final data = res.data as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

@riverpod
Future<Map<String, double>> exchangeRates(ExchangeRatesRef ref) =>
    ref.watch(exchangeRateRepositoryProvider).getRates();
