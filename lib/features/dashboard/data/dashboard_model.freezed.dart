// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) {
  return _DashboardData.fromJson(json);
}

/// @nodoc
mixin _$DashboardData {
  int get totalQuotes => throw _privateConstructorUsedError;
  int get pendingQuotes => throw _privateConstructorUsedError;
  int get approvedQuotes => throw _privateConstructorUsedError;
  int get todayVisits => throw _privateConstructorUsedError;
  List<RecentQuote> get recentQuotes => throw _privateConstructorUsedError;

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
          DashboardData value, $Res Function(DashboardData) then) =
      _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call(
      {int totalQuotes,
      int pendingQuotes,
      int approvedQuotes,
      int todayVisits,
      List<RecentQuote> recentQuotes});
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuotes = null,
    Object? pendingQuotes = null,
    Object? approvedQuotes = null,
    Object? todayVisits = null,
    Object? recentQuotes = null,
  }) {
    return _then(_value.copyWith(
      totalQuotes: null == totalQuotes
          ? _value.totalQuotes
          : totalQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      pendingQuotes: null == pendingQuotes
          ? _value.pendingQuotes
          : pendingQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      approvedQuotes: null == approvedQuotes
          ? _value.approvedQuotes
          : approvedQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      todayVisits: null == todayVisits
          ? _value.todayVisits
          : todayVisits // ignore: cast_nullable_to_non_nullable
              as int,
      recentQuotes: null == recentQuotes
          ? _value.recentQuotes
          : recentQuotes // ignore: cast_nullable_to_non_nullable
              as List<RecentQuote>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
          _$DashboardDataImpl value, $Res Function(_$DashboardDataImpl) then) =
      __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalQuotes,
      int pendingQuotes,
      int approvedQuotes,
      int todayVisits,
      List<RecentQuote> recentQuotes});
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
      _$DashboardDataImpl _value, $Res Function(_$DashboardDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuotes = null,
    Object? pendingQuotes = null,
    Object? approvedQuotes = null,
    Object? todayVisits = null,
    Object? recentQuotes = null,
  }) {
    return _then(_$DashboardDataImpl(
      totalQuotes: null == totalQuotes
          ? _value.totalQuotes
          : totalQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      pendingQuotes: null == pendingQuotes
          ? _value.pendingQuotes
          : pendingQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      approvedQuotes: null == approvedQuotes
          ? _value.approvedQuotes
          : approvedQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      todayVisits: null == todayVisits
          ? _value.todayVisits
          : todayVisits // ignore: cast_nullable_to_non_nullable
              as int,
      recentQuotes: null == recentQuotes
          ? _value._recentQuotes
          : recentQuotes // ignore: cast_nullable_to_non_nullable
              as List<RecentQuote>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl(
      {required this.totalQuotes,
      required this.pendingQuotes,
      required this.approvedQuotes,
      required this.todayVisits,
      required final List<RecentQuote> recentQuotes})
      : _recentQuotes = recentQuotes;

  factory _$DashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataImplFromJson(json);

  @override
  final int totalQuotes;
  @override
  final int pendingQuotes;
  @override
  final int approvedQuotes;
  @override
  final int todayVisits;
  final List<RecentQuote> _recentQuotes;
  @override
  List<RecentQuote> get recentQuotes {
    if (_recentQuotes is EqualUnmodifiableListView) return _recentQuotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentQuotes);
  }

  @override
  String toString() {
    return 'DashboardData(totalQuotes: $totalQuotes, pendingQuotes: $pendingQuotes, approvedQuotes: $approvedQuotes, todayVisits: $todayVisits, recentQuotes: $recentQuotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.totalQuotes, totalQuotes) ||
                other.totalQuotes == totalQuotes) &&
            (identical(other.pendingQuotes, pendingQuotes) ||
                other.pendingQuotes == pendingQuotes) &&
            (identical(other.approvedQuotes, approvedQuotes) ||
                other.approvedQuotes == approvedQuotes) &&
            (identical(other.todayVisits, todayVisits) ||
                other.todayVisits == todayVisits) &&
            const DeepCollectionEquality()
                .equals(other._recentQuotes, _recentQuotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalQuotes,
      pendingQuotes,
      approvedQuotes,
      todayVisits,
      const DeepCollectionEquality().hash(_recentQuotes));

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataImplToJson(
      this,
    );
  }
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData(
      {required final int totalQuotes,
      required final int pendingQuotes,
      required final int approvedQuotes,
      required final int todayVisits,
      required final List<RecentQuote> recentQuotes}) = _$DashboardDataImpl;

  factory _DashboardData.fromJson(Map<String, dynamic> json) =
      _$DashboardDataImpl.fromJson;

  @override
  int get totalQuotes;
  @override
  int get pendingQuotes;
  @override
  int get approvedQuotes;
  @override
  int get todayVisits;
  @override
  List<RecentQuote> get recentQuotes;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentQuote _$RecentQuoteFromJson(Map<String, dynamic> json) {
  return _RecentQuote.fromJson(json);
}

/// @nodoc
mixin _$RecentQuote {
  String get id => throw _privateConstructorUsedError;
  String get quoteNumber => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this RecentQuote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentQuoteCopyWith<RecentQuote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentQuoteCopyWith<$Res> {
  factory $RecentQuoteCopyWith(
          RecentQuote value, $Res Function(RecentQuote) then) =
      _$RecentQuoteCopyWithImpl<$Res, RecentQuote>;
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String customerName,
      int status,
      DateTime date,
      String currency});
}

/// @nodoc
class _$RecentQuoteCopyWithImpl<$Res, $Val extends RecentQuote>
    implements $RecentQuoteCopyWith<$Res> {
  _$RecentQuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? customerName = null,
    Object? status = null,
    Object? date = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentQuoteImplCopyWith<$Res>
    implements $RecentQuoteCopyWith<$Res> {
  factory _$$RecentQuoteImplCopyWith(
          _$RecentQuoteImpl value, $Res Function(_$RecentQuoteImpl) then) =
      __$$RecentQuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String customerName,
      int status,
      DateTime date,
      String currency});
}

/// @nodoc
class __$$RecentQuoteImplCopyWithImpl<$Res>
    extends _$RecentQuoteCopyWithImpl<$Res, _$RecentQuoteImpl>
    implements _$$RecentQuoteImplCopyWith<$Res> {
  __$$RecentQuoteImplCopyWithImpl(
      _$RecentQuoteImpl _value, $Res Function(_$RecentQuoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? customerName = null,
    Object? status = null,
    Object? date = null,
    Object? currency = null,
  }) {
    return _then(_$RecentQuoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentQuoteImpl implements _RecentQuote {
  const _$RecentQuoteImpl(
      {required this.id,
      required this.quoteNumber,
      required this.customerName,
      required this.status,
      required this.date,
      required this.currency});

  factory _$RecentQuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentQuoteImplFromJson(json);

  @override
  final String id;
  @override
  final String quoteNumber;
  @override
  final String customerName;
  @override
  final int status;
  @override
  final DateTime date;
  @override
  final String currency;

  @override
  String toString() {
    return 'RecentQuote(id: $id, quoteNumber: $quoteNumber, customerName: $customerName, status: $status, date: $date, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentQuoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteNumber, quoteNumber) ||
                other.quoteNumber == quoteNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, quoteNumber, customerName, status, date, currency);

  /// Create a copy of RecentQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentQuoteImplCopyWith<_$RecentQuoteImpl> get copyWith =>
      __$$RecentQuoteImplCopyWithImpl<_$RecentQuoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentQuoteImplToJson(
      this,
    );
  }
}

abstract class _RecentQuote implements RecentQuote {
  const factory _RecentQuote(
      {required final String id,
      required final String quoteNumber,
      required final String customerName,
      required final int status,
      required final DateTime date,
      required final String currency}) = _$RecentQuoteImpl;

  factory _RecentQuote.fromJson(Map<String, dynamic> json) =
      _$RecentQuoteImpl.fromJson;

  @override
  String get id;
  @override
  String get quoteNumber;
  @override
  String get customerName;
  @override
  int get status;
  @override
  DateTime get date;
  @override
  String get currency;

  /// Create a copy of RecentQuote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentQuoteImplCopyWith<_$RecentQuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
