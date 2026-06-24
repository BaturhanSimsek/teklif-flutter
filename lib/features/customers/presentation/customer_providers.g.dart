// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customersHash() => r'a0865486f8a47a2d33f9788d6be8b3c32b1d3841';

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

/// See also [customers].
@ProviderFor(customers)
const customersProvider = CustomersFamily();

/// See also [customers].
class CustomersFamily extends Family<AsyncValue<List<Customer>>> {
  /// See also [customers].
  const CustomersFamily();

  /// See also [customers].
  CustomersProvider call({
    String? search,
  }) {
    return CustomersProvider(
      search: search,
    );
  }

  @override
  CustomersProvider getProviderOverride(
    covariant CustomersProvider provider,
  ) {
    return call(
      search: provider.search,
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
  String? get name => r'customersProvider';
}

/// See also [customers].
class CustomersProvider extends AutoDisposeFutureProvider<List<Customer>> {
  /// See also [customers].
  CustomersProvider({
    String? search,
  }) : this._internal(
          (ref) => customers(
            ref as CustomersRef,
            search: search,
          ),
          from: customersProvider,
          name: r'customersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customersHash,
          dependencies: CustomersFamily._dependencies,
          allTransitiveDependencies: CustomersFamily._allTransitiveDependencies,
          search: search,
        );

  CustomersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
  }) : super.internal();

  final String? search;

  @override
  Override overrideWith(
    FutureOr<List<Customer>> Function(CustomersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersProvider._internal(
        (ref) => create(ref as CustomersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Customer>> createElement() {
    return _CustomersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersProvider && other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersRef on AutoDisposeFutureProviderRef<List<Customer>> {
  /// The parameter `search` of this provider.
  String? get search;
}

class _CustomersProviderElement
    extends AutoDisposeFutureProviderElement<List<Customer>> with CustomersRef {
  _CustomersProviderElement(super.provider);

  @override
  String? get search => (origin as CustomersProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
