// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotesByCustomerHash() => r'6b31d4441586cee86cbd98a9d73e321997429002';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [quotesByCustomer].
@ProviderFor(quotesByCustomer)
const quotesByCustomerProvider = QuotesByCustomerFamily();

/// See also [quotesByCustomer].
class QuotesByCustomerFamily extends Family<AsyncValue<List<QuoteSummary>>> {
  /// See also [quotesByCustomer].
  const QuotesByCustomerFamily();

  /// See also [quotesByCustomer].
  QuotesByCustomerProvider call(
    String customerId,
  ) {
    return QuotesByCustomerProvider(
      customerId,
    );
  }

  @override
  QuotesByCustomerProvider getProviderOverride(
    covariant QuotesByCustomerProvider provider,
  ) {
    return call(
      provider.customerId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quotesByCustomerProvider';
}

/// See also [quotesByCustomer].
class QuotesByCustomerProvider
    extends AutoDisposeFutureProvider<List<QuoteSummary>> {
  /// See also [quotesByCustomer].
  QuotesByCustomerProvider(
    String customerId,
  ) : this._internal(
          (ref) => quotesByCustomer(
            ref as QuotesByCustomerRef,
            customerId,
          ),
          from: quotesByCustomerProvider,
          name: r'quotesByCustomerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quotesByCustomerHash,
          dependencies: QuotesByCustomerFamily._dependencies,
          allTransitiveDependencies:
              QuotesByCustomerFamily._allTransitiveDependencies,
          customerId: customerId,
        );

  QuotesByCustomerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customerId,
  }) : super.internal();

  final String customerId;

  @override
  Override overrideWith(
    FutureOr<List<QuoteSummary>> Function(QuotesByCustomerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuotesByCustomerProvider._internal(
        (ref) => create(ref as QuotesByCustomerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customerId: customerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<QuoteSummary>> createElement() {
    return _QuotesByCustomerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuotesByCustomerProvider && other.customerId == customerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuotesByCustomerRef on AutoDisposeFutureProviderRef<List<QuoteSummary>> {
  /// The parameter `customerId` of this provider.
  String get customerId;
}

class _QuotesByCustomerProviderElement
    extends AutoDisposeFutureProviderElement<List<QuoteSummary>>
    with QuotesByCustomerRef {
  _QuotesByCustomerProviderElement(super.provider);

  @override
  String get customerId => (origin as QuotesByCustomerProvider).customerId;
}

String _$quoteDetailHash() => r'd674faad049cd3454848837225172ee045b43b64';

/// See also [quoteDetail].
@ProviderFor(quoteDetail)
const quoteDetailProvider = QuoteDetailFamily();

/// See also [quoteDetail].
class QuoteDetailFamily extends Family<AsyncValue<QuoteDetail>> {
  /// See also [quoteDetail].
  const QuoteDetailFamily();

  /// See also [quoteDetail].
  QuoteDetailProvider call(
    String quoteId,
  ) {
    return QuoteDetailProvider(
      quoteId,
    );
  }

  @override
  QuoteDetailProvider getProviderOverride(
    covariant QuoteDetailProvider provider,
  ) {
    return call(
      provider.quoteId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quoteDetailProvider';
}

/// See also [quoteDetail].
class QuoteDetailProvider extends AutoDisposeFutureProvider<QuoteDetail> {
  /// See also [quoteDetail].
  QuoteDetailProvider(
    String quoteId,
  ) : this._internal(
          (ref) => quoteDetail(
            ref as QuoteDetailRef,
            quoteId,
          ),
          from: quoteDetailProvider,
          name: r'quoteDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quoteDetailHash,
          dependencies: QuoteDetailFamily._dependencies,
          allTransitiveDependencies:
              QuoteDetailFamily._allTransitiveDependencies,
          quoteId: quoteId,
        );

  QuoteDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quoteId,
  }) : super.internal();

  final String quoteId;

  @override
  Override overrideWith(
    FutureOr<QuoteDetail> Function(QuoteDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuoteDetailProvider._internal(
        (ref) => create(ref as QuoteDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quoteId: quoteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<QuoteDetail> createElement() {
    return _QuoteDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteDetailProvider && other.quoteId == quoteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quoteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuoteDetailRef on AutoDisposeFutureProviderRef<QuoteDetail> {
  /// The parameter `quoteId` of this provider.
  String get quoteId;
}

class _QuoteDetailProviderElement
    extends AutoDisposeFutureProviderElement<QuoteDetail> with QuoteDetailRef {
  _QuoteDetailProviderElement(super.provider);

  @override
  String get quoteId => (origin as QuoteDetailProvider).quoteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
