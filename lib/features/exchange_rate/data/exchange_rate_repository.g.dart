// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exchangeRateRepositoryHash() =>
    r'08686834a02b721d5f90b6bd026b873a64c4c2a4';

/// See also [exchangeRateRepository].
@ProviderFor(exchangeRateRepository)
final exchangeRateRepositoryProvider =
    AutoDisposeProvider<ExchangeRateRepository>.internal(
  exchangeRateRepository,
  name: r'exchangeRateRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exchangeRateRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExchangeRateRepositoryRef
    = AutoDisposeProviderRef<ExchangeRateRepository>;
String _$exchangeRatesHash() => r'02445dec3c6ad43550f70774c70438c23b90a816';

/// See also [exchangeRates].
@ProviderFor(exchangeRates)
final exchangeRatesProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
  exchangeRates,
  name: r'exchangeRatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exchangeRatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExchangeRatesRef = AutoDisposeFutureProviderRef<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
