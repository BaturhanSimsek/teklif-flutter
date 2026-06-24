// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allQuotesHash() => r'ec4547aa1fc2d9c12bd8c7fd16a3aabe5eb2a98b';

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

/// See also [allQuotes].
@ProviderFor(allQuotes)
const allQuotesProvider = AllQuotesFamily();

/// See also [allQuotes].
class AllQuotesFamily extends Family<AsyncValue<PagedResult<QuoteSummary>>> {
  /// See also [allQuotes].
  const AllQuotesFamily();

  /// See also [allQuotes].
  AllQuotesProvider call({
    String? customerId,
    String? search,
    int page = 1,
  }) {
    return AllQuotesProvider(
      customerId: customerId,
      search: search,
      page: page,
    );
  }

  @override
  AllQuotesProvider getProviderOverride(
    covariant AllQuotesProvider provider,
  ) {
    return call(
      customerId: provider.customerId,
      search: provider.search,
      page: provider.page,
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
  String? get name => r'allQuotesProvider';
}

/// See also [allQuotes].
class AllQuotesProvider
    extends AutoDisposeFutureProvider<PagedResult<QuoteSummary>> {
  /// See also [allQuotes].
  AllQuotesProvider({
    String? customerId,
    String? search,
    int page = 1,
  }) : this._internal(
          (ref) => allQuotes(
            ref as AllQuotesRef,
            customerId: customerId,
            search: search,
            page: page,
          ),
          from: allQuotesProvider,
          name: r'allQuotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allQuotesHash,
          dependencies: AllQuotesFamily._dependencies,
          allTransitiveDependencies: AllQuotesFamily._allTransitiveDependencies,
          customerId: customerId,
          search: search,
          page: page,
        );

  AllQuotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customerId,
    required this.search,
    required this.page,
  }) : super.internal();

  final String? customerId;
  final String? search;
  final int page;

  @override
  Override overrideWith(
    FutureOr<PagedResult<QuoteSummary>> Function(AllQuotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllQuotesProvider._internal(
        (ref) => create(ref as AllQuotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customerId: customerId,
        search: search,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PagedResult<QuoteSummary>> createElement() {
    return _AllQuotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllQuotesProvider &&
        other.customerId == customerId &&
        other.search == search &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllQuotesRef on AutoDisposeFutureProviderRef<PagedResult<QuoteSummary>> {
  /// The parameter `customerId` of this provider.
  String? get customerId;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `page` of this provider.
  int get page;
}

class _AllQuotesProviderElement
    extends AutoDisposeFutureProviderElement<PagedResult<QuoteSummary>>
    with AllQuotesRef {
  _AllQuotesProviderElement(super.provider);

  @override
  String? get customerId => (origin as AllQuotesProvider).customerId;
  @override
  String? get search => (origin as AllQuotesProvider).search;
  @override
  int get page => (origin as AllQuotesProvider).page;
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
