// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_revisions_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quoteRevisionsHash() => r'aa6e193f2d1586625b5cec07ee916d7ab0c93a6c';

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

/// See also [quoteRevisions].
@ProviderFor(quoteRevisions)
const quoteRevisionsProvider = QuoteRevisionsFamily();

/// See also [quoteRevisions].
class QuoteRevisionsFamily extends Family<AsyncValue<List<QuoteSummary>>> {
  /// See also [quoteRevisions].
  const QuoteRevisionsFamily();

  /// See also [quoteRevisions].
  QuoteRevisionsProvider call(
    String quoteId,
  ) {
    return QuoteRevisionsProvider(
      quoteId,
    );
  }

  @override
  QuoteRevisionsProvider getProviderOverride(
    covariant QuoteRevisionsProvider provider,
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
  String? get name => r'quoteRevisionsProvider';
}

/// See also [quoteRevisions].
class QuoteRevisionsProvider
    extends AutoDisposeFutureProvider<List<QuoteSummary>> {
  /// See also [quoteRevisions].
  QuoteRevisionsProvider(
    String quoteId,
  ) : this._internal(
          (ref) => quoteRevisions(
            ref as QuoteRevisionsRef,
            quoteId,
          ),
          from: quoteRevisionsProvider,
          name: r'quoteRevisionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quoteRevisionsHash,
          dependencies: QuoteRevisionsFamily._dependencies,
          allTransitiveDependencies:
              QuoteRevisionsFamily._allTransitiveDependencies,
          quoteId: quoteId,
        );

  QuoteRevisionsProvider._internal(
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
    FutureOr<List<QuoteSummary>> Function(QuoteRevisionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuoteRevisionsProvider._internal(
        (ref) => create(ref as QuoteRevisionsRef),
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
  AutoDisposeFutureProviderElement<List<QuoteSummary>> createElement() {
    return _QuoteRevisionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteRevisionsProvider && other.quoteId == quoteId;
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
mixin QuoteRevisionsRef on AutoDisposeFutureProviderRef<List<QuoteSummary>> {
  /// The parameter `quoteId` of this provider.
  String get quoteId;
}

class _QuoteRevisionsProviderElement
    extends AutoDisposeFutureProviderElement<List<QuoteSummary>>
    with QuoteRevisionsRef {
  _QuoteRevisionsProviderElement(super.provider);

  @override
  String get quoteId => (origin as QuoteRevisionsProvider).quoteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
