// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteSummary _$QuoteSummaryFromJson(Map<String, dynamic> json) {
  return _QuoteSummary.fromJson(json);
}

/// @nodoc
mixin _$QuoteSummary {
  String get id => throw _privateConstructorUsedError;
  String get quoteNumber => throw _privateConstructorUsedError;
  String get quoteNumberDisplay => throw _privateConstructorUsedError;
  int get revisionNo => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  String get formTemplateName => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  String get createdByEmail => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuoteSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteSummaryCopyWith<QuoteSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteSummaryCopyWith<$Res> {
  factory $QuoteSummaryCopyWith(
          QuoteSummary value, $Res Function(QuoteSummary) then) =
      _$QuoteSummaryCopyWithImpl<$Res, QuoteSummary>;
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String quoteNumberDisplay,
      int revisionNo,
      int status,
      bool isApproved,
      String formTemplateName,
      String currency,
      String language,
      double grandTotal,
      String createdByEmail,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$QuoteSummaryCopyWithImpl<$Res, $Val extends QuoteSummary>
    implements $QuoteSummaryCopyWith<$Res> {
  _$QuoteSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? quoteNumberDisplay = null,
    Object? revisionNo = null,
    Object? status = null,
    Object? isApproved = null,
    Object? formTemplateName = null,
    Object? currency = null,
    Object? language = null,
    Object? grandTotal = null,
    Object? createdByEmail = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      quoteNumberDisplay: null == quoteNumberDisplay
          ? _value.quoteNumberDisplay
          : quoteNumberDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      revisionNo: null == revisionNo
          ? _value.revisionNo
          : revisionNo // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      formTemplateName: null == formTemplateName
          ? _value.formTemplateName
          : formTemplateName // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      createdByEmail: null == createdByEmail
          ? _value.createdByEmail
          : createdByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteSummaryImplCopyWith<$Res>
    implements $QuoteSummaryCopyWith<$Res> {
  factory _$$QuoteSummaryImplCopyWith(
          _$QuoteSummaryImpl value, $Res Function(_$QuoteSummaryImpl) then) =
      __$$QuoteSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String quoteNumberDisplay,
      int revisionNo,
      int status,
      bool isApproved,
      String formTemplateName,
      String currency,
      String language,
      double grandTotal,
      String createdByEmail,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$QuoteSummaryImplCopyWithImpl<$Res>
    extends _$QuoteSummaryCopyWithImpl<$Res, _$QuoteSummaryImpl>
    implements _$$QuoteSummaryImplCopyWith<$Res> {
  __$$QuoteSummaryImplCopyWithImpl(
      _$QuoteSummaryImpl _value, $Res Function(_$QuoteSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? quoteNumberDisplay = null,
    Object? revisionNo = null,
    Object? status = null,
    Object? isApproved = null,
    Object? formTemplateName = null,
    Object? currency = null,
    Object? language = null,
    Object? grandTotal = null,
    Object? createdByEmail = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$QuoteSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumberDisplay: null == quoteNumberDisplay
          ? _value.quoteNumberDisplay
          : quoteNumberDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      revisionNo: null == revisionNo
          ? _value.revisionNo
          : revisionNo // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      formTemplateName: null == formTemplateName
          ? _value.formTemplateName
          : formTemplateName // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      createdByEmail: null == createdByEmail
          ? _value.createdByEmail
          : createdByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteSummaryImpl implements _QuoteSummary {
  const _$QuoteSummaryImpl(
      {required this.id,
      required this.quoteNumber,
      required this.quoteNumberDisplay,
      required this.revisionNo,
      required this.status,
      required this.isApproved,
      required this.formTemplateName,
      required this.currency,
      required this.language,
      required this.grandTotal,
      required this.createdByEmail,
      required this.createdAt,
      this.updatedAt});

  factory _$QuoteSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String quoteNumber;
  @override
  final String quoteNumberDisplay;
  @override
  final int revisionNo;
  @override
  final int status;
  @override
  final bool isApproved;
  @override
  final String formTemplateName;
  @override
  final String currency;
  @override
  final String language;
  @override
  final double grandTotal;
  @override
  final String createdByEmail;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'QuoteSummary(id: $id, quoteNumber: $quoteNumber, quoteNumberDisplay: $quoteNumberDisplay, revisionNo: $revisionNo, status: $status, isApproved: $isApproved, formTemplateName: $formTemplateName, currency: $currency, language: $language, grandTotal: $grandTotal, createdByEmail: $createdByEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteNumber, quoteNumber) ||
                other.quoteNumber == quoteNumber) &&
            (identical(other.quoteNumberDisplay, quoteNumberDisplay) ||
                other.quoteNumberDisplay == quoteNumberDisplay) &&
            (identical(other.revisionNo, revisionNo) ||
                other.revisionNo == revisionNo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.formTemplateName, formTemplateName) ||
                other.formTemplateName == formTemplateName) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.createdByEmail, createdByEmail) ||
                other.createdByEmail == createdByEmail) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quoteNumber,
      quoteNumberDisplay,
      revisionNo,
      status,
      isApproved,
      formTemplateName,
      currency,
      language,
      grandTotal,
      createdByEmail,
      createdAt,
      updatedAt);

  /// Create a copy of QuoteSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteSummaryImplCopyWith<_$QuoteSummaryImpl> get copyWith =>
      __$$QuoteSummaryImplCopyWithImpl<_$QuoteSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteSummaryImplToJson(
      this,
    );
  }
}

abstract class _QuoteSummary implements QuoteSummary {
  const factory _QuoteSummary(
      {required final String id,
      required final String quoteNumber,
      required final String quoteNumberDisplay,
      required final int revisionNo,
      required final int status,
      required final bool isApproved,
      required final String formTemplateName,
      required final String currency,
      required final String language,
      required final double grandTotal,
      required final String createdByEmail,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$QuoteSummaryImpl;

  factory _QuoteSummary.fromJson(Map<String, dynamic> json) =
      _$QuoteSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get quoteNumber;
  @override
  String get quoteNumberDisplay;
  @override
  int get revisionNo;
  @override
  int get status;
  @override
  bool get isApproved;
  @override
  String get formTemplateName;
  @override
  String get currency;
  @override
  String get language;
  @override
  double get grandTotal;
  @override
  String get createdByEmail;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of QuoteSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteSummaryImplCopyWith<_$QuoteSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuoteDetail _$QuoteDetailFromJson(Map<String, dynamic> json) {
  return _QuoteDetail.fromJson(json);
}

/// @nodoc
mixin _$QuoteDetail {
  String get id => throw _privateConstructorUsedError;
  String get quoteNumber => throw _privateConstructorUsedError;
  String get quoteNumberDisplay => throw _privateConstructorUsedError;
  int get revisionNo => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get formTemplateId => throw _privateConstructorUsedError;
  String get formTemplateName => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get paymentTerm => throw _privateConstructorUsedError;
  String get deliveryDays => throw _privateConstructorUsedError;
  double get kdvRate => throw _privateConstructorUsedError;
  double get discountRate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  double get subTotal => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get kdvAmount => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  String get createdByEmail => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get shareToken => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  DateTime? get viewedAt => throw _privateConstructorUsedError;
  List<QuoteItemDetail> get items => throw _privateConstructorUsedError;

  /// Serializes this QuoteDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteDetailCopyWith<QuoteDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteDetailCopyWith<$Res> {
  factory $QuoteDetailCopyWith(
          QuoteDetail value, $Res Function(QuoteDetail) then) =
      _$QuoteDetailCopyWithImpl<$Res, QuoteDetail>;
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String quoteNumberDisplay,
      int revisionNo,
      int status,
      bool isApproved,
      String customerId,
      String customerName,
      String customerPhone,
      String formTemplateId,
      String formTemplateName,
      String language,
      String currency,
      DateTime date,
      String paymentTerm,
      String deliveryDays,
      double kdvRate,
      double discountRate,
      String? notes,
      double subTotal,
      double discountAmount,
      double kdvAmount,
      double grandTotal,
      String createdByEmail,
      DateTime createdAt,
      DateTime? updatedAt,
      String? shareToken,
      int viewCount,
      DateTime? viewedAt,
      List<QuoteItemDetail> items});
}

/// @nodoc
class _$QuoteDetailCopyWithImpl<$Res, $Val extends QuoteDetail>
    implements $QuoteDetailCopyWith<$Res> {
  _$QuoteDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? quoteNumberDisplay = null,
    Object? revisionNo = null,
    Object? status = null,
    Object? isApproved = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? formTemplateId = null,
    Object? formTemplateName = null,
    Object? language = null,
    Object? currency = null,
    Object? date = null,
    Object? paymentTerm = null,
    Object? deliveryDays = null,
    Object? kdvRate = null,
    Object? discountRate = null,
    Object? notes = freezed,
    Object? subTotal = null,
    Object? discountAmount = null,
    Object? kdvAmount = null,
    Object? grandTotal = null,
    Object? createdByEmail = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? shareToken = freezed,
    Object? viewCount = null,
    Object? viewedAt = freezed,
    Object? items = null,
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
      quoteNumberDisplay: null == quoteNumberDisplay
          ? _value.quoteNumberDisplay
          : quoteNumberDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      revisionNo: null == revisionNo
          ? _value.revisionNo
          : revisionNo // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      formTemplateId: null == formTemplateId
          ? _value.formTemplateId
          : formTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      formTemplateName: null == formTemplateName
          ? _value.formTemplateName
          : formTemplateName // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentTerm: null == paymentTerm
          ? _value.paymentTerm
          : paymentTerm // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryDays: null == deliveryDays
          ? _value.deliveryDays
          : deliveryDays // ignore: cast_nullable_to_non_nullable
              as String,
      kdvRate: null == kdvRate
          ? _value.kdvRate
          : kdvRate // ignore: cast_nullable_to_non_nullable
              as double,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      kdvAmount: null == kdvAmount
          ? _value.kdvAmount
          : kdvAmount // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      createdByEmail: null == createdByEmail
          ? _value.createdByEmail
          : createdByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewedAt: freezed == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<QuoteItemDetail>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteDetailImplCopyWith<$Res>
    implements $QuoteDetailCopyWith<$Res> {
  factory _$$QuoteDetailImplCopyWith(
          _$QuoteDetailImpl value, $Res Function(_$QuoteDetailImpl) then) =
      __$$QuoteDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String quoteNumber,
      String quoteNumberDisplay,
      int revisionNo,
      int status,
      bool isApproved,
      String customerId,
      String customerName,
      String customerPhone,
      String formTemplateId,
      String formTemplateName,
      String language,
      String currency,
      DateTime date,
      String paymentTerm,
      String deliveryDays,
      double kdvRate,
      double discountRate,
      String? notes,
      double subTotal,
      double discountAmount,
      double kdvAmount,
      double grandTotal,
      String createdByEmail,
      DateTime createdAt,
      DateTime? updatedAt,
      String? shareToken,
      int viewCount,
      DateTime? viewedAt,
      List<QuoteItemDetail> items});
}

/// @nodoc
class __$$QuoteDetailImplCopyWithImpl<$Res>
    extends _$QuoteDetailCopyWithImpl<$Res, _$QuoteDetailImpl>
    implements _$$QuoteDetailImplCopyWith<$Res> {
  __$$QuoteDetailImplCopyWithImpl(
      _$QuoteDetailImpl _value, $Res Function(_$QuoteDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quoteNumber = null,
    Object? quoteNumberDisplay = null,
    Object? revisionNo = null,
    Object? status = null,
    Object? isApproved = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? formTemplateId = null,
    Object? formTemplateName = null,
    Object? language = null,
    Object? currency = null,
    Object? date = null,
    Object? paymentTerm = null,
    Object? deliveryDays = null,
    Object? kdvRate = null,
    Object? discountRate = null,
    Object? notes = freezed,
    Object? subTotal = null,
    Object? discountAmount = null,
    Object? kdvAmount = null,
    Object? grandTotal = null,
    Object? createdByEmail = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? shareToken = freezed,
    Object? viewCount = null,
    Object? viewedAt = freezed,
    Object? items = null,
  }) {
    return _then(_$QuoteDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumberDisplay: null == quoteNumberDisplay
          ? _value.quoteNumberDisplay
          : quoteNumberDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      revisionNo: null == revisionNo
          ? _value.revisionNo
          : revisionNo // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      formTemplateId: null == formTemplateId
          ? _value.formTemplateId
          : formTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      formTemplateName: null == formTemplateName
          ? _value.formTemplateName
          : formTemplateName // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentTerm: null == paymentTerm
          ? _value.paymentTerm
          : paymentTerm // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryDays: null == deliveryDays
          ? _value.deliveryDays
          : deliveryDays // ignore: cast_nullable_to_non_nullable
              as String,
      kdvRate: null == kdvRate
          ? _value.kdvRate
          : kdvRate // ignore: cast_nullable_to_non_nullable
              as double,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      kdvAmount: null == kdvAmount
          ? _value.kdvAmount
          : kdvAmount // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      createdByEmail: null == createdByEmail
          ? _value.createdByEmail
          : createdByEmail // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewedAt: freezed == viewedAt
          ? _value.viewedAt
          : viewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<QuoteItemDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteDetailImpl implements _QuoteDetail {
  const _$QuoteDetailImpl(
      {required this.id,
      required this.quoteNumber,
      required this.quoteNumberDisplay,
      required this.revisionNo,
      required this.status,
      required this.isApproved,
      required this.customerId,
      required this.customerName,
      required this.customerPhone,
      required this.formTemplateId,
      required this.formTemplateName,
      required this.language,
      required this.currency,
      required this.date,
      required this.paymentTerm,
      required this.deliveryDays,
      required this.kdvRate,
      required this.discountRate,
      this.notes,
      required this.subTotal,
      required this.discountAmount,
      required this.kdvAmount,
      required this.grandTotal,
      required this.createdByEmail,
      required this.createdAt,
      this.updatedAt,
      this.shareToken,
      this.viewCount = 0,
      this.viewedAt,
      required final List<QuoteItemDetail> items})
      : _items = items;

  factory _$QuoteDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String quoteNumber;
  @override
  final String quoteNumberDisplay;
  @override
  final int revisionNo;
  @override
  final int status;
  @override
  final bool isApproved;
  @override
  final String customerId;
  @override
  final String customerName;
  @override
  final String customerPhone;
  @override
  final String formTemplateId;
  @override
  final String formTemplateName;
  @override
  final String language;
  @override
  final String currency;
  @override
  final DateTime date;
  @override
  final String paymentTerm;
  @override
  final String deliveryDays;
  @override
  final double kdvRate;
  @override
  final double discountRate;
  @override
  final String? notes;
  @override
  final double subTotal;
  @override
  final double discountAmount;
  @override
  final double kdvAmount;
  @override
  final double grandTotal;
  @override
  final String createdByEmail;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? shareToken;
  @override
  @JsonKey()
  final int viewCount;
  @override
  final DateTime? viewedAt;
  final List<QuoteItemDetail> _items;
  @override
  List<QuoteItemDetail> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'QuoteDetail(id: $id, quoteNumber: $quoteNumber, quoteNumberDisplay: $quoteNumberDisplay, revisionNo: $revisionNo, status: $status, isApproved: $isApproved, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, formTemplateId: $formTemplateId, formTemplateName: $formTemplateName, language: $language, currency: $currency, date: $date, paymentTerm: $paymentTerm, deliveryDays: $deliveryDays, kdvRate: $kdvRate, discountRate: $discountRate, notes: $notes, subTotal: $subTotal, discountAmount: $discountAmount, kdvAmount: $kdvAmount, grandTotal: $grandTotal, createdByEmail: $createdByEmail, createdAt: $createdAt, updatedAt: $updatedAt, shareToken: $shareToken, viewCount: $viewCount, viewedAt: $viewedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteNumber, quoteNumber) ||
                other.quoteNumber == quoteNumber) &&
            (identical(other.quoteNumberDisplay, quoteNumberDisplay) ||
                other.quoteNumberDisplay == quoteNumberDisplay) &&
            (identical(other.revisionNo, revisionNo) ||
                other.revisionNo == revisionNo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.formTemplateId, formTemplateId) ||
                other.formTemplateId == formTemplateId) &&
            (identical(other.formTemplateName, formTemplateName) ||
                other.formTemplateName == formTemplateName) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.paymentTerm, paymentTerm) ||
                other.paymentTerm == paymentTerm) &&
            (identical(other.deliveryDays, deliveryDays) ||
                other.deliveryDays == deliveryDays) &&
            (identical(other.kdvRate, kdvRate) || other.kdvRate == kdvRate) &&
            (identical(other.discountRate, discountRate) ||
                other.discountRate == discountRate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.kdvAmount, kdvAmount) ||
                other.kdvAmount == kdvAmount) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.createdByEmail, createdByEmail) ||
                other.createdByEmail == createdByEmail) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.viewedAt, viewedAt) ||
                other.viewedAt == viewedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        quoteNumber,
        quoteNumberDisplay,
        revisionNo,
        status,
        isApproved,
        customerId,
        customerName,
        customerPhone,
        formTemplateId,
        formTemplateName,
        language,
        currency,
        date,
        paymentTerm,
        deliveryDays,
        kdvRate,
        discountRate,
        notes,
        subTotal,
        discountAmount,
        kdvAmount,
        grandTotal,
        createdByEmail,
        createdAt,
        updatedAt,
        shareToken,
        viewCount,
        viewedAt,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of QuoteDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteDetailImplCopyWith<_$QuoteDetailImpl> get copyWith =>
      __$$QuoteDetailImplCopyWithImpl<_$QuoteDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteDetailImplToJson(
      this,
    );
  }
}

abstract class _QuoteDetail implements QuoteDetail {
  const factory _QuoteDetail(
      {required final String id,
      required final String quoteNumber,
      required final String quoteNumberDisplay,
      required final int revisionNo,
      required final int status,
      required final bool isApproved,
      required final String customerId,
      required final String customerName,
      required final String customerPhone,
      required final String formTemplateId,
      required final String formTemplateName,
      required final String language,
      required final String currency,
      required final DateTime date,
      required final String paymentTerm,
      required final String deliveryDays,
      required final double kdvRate,
      required final double discountRate,
      final String? notes,
      required final double subTotal,
      required final double discountAmount,
      required final double kdvAmount,
      required final double grandTotal,
      required final String createdByEmail,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String? shareToken,
      final int viewCount,
      final DateTime? viewedAt,
      required final List<QuoteItemDetail> items}) = _$QuoteDetailImpl;

  factory _QuoteDetail.fromJson(Map<String, dynamic> json) =
      _$QuoteDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get quoteNumber;
  @override
  String get quoteNumberDisplay;
  @override
  int get revisionNo;
  @override
  int get status;
  @override
  bool get isApproved;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get formTemplateId;
  @override
  String get formTemplateName;
  @override
  String get language;
  @override
  String get currency;
  @override
  DateTime get date;
  @override
  String get paymentTerm;
  @override
  String get deliveryDays;
  @override
  double get kdvRate;
  @override
  double get discountRate;
  @override
  String? get notes;
  @override
  double get subTotal;
  @override
  double get discountAmount;
  @override
  double get kdvAmount;
  @override
  double get grandTotal;
  @override
  String get createdByEmail;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get shareToken;
  @override
  int get viewCount;
  @override
  DateTime? get viewedAt;
  @override
  List<QuoteItemDetail> get items;

  /// Create a copy of QuoteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteDetailImplCopyWith<_$QuoteDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuoteItemDetail _$QuoteItemDetailFromJson(Map<String, dynamic> json) {
  return _QuoteItemDetail.fromJson(json);
}

/// @nodoc
mixin _$QuoteItemDetail {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  Map<String, dynamic> get customFields => throw _privateConstructorUsedError;

  /// Serializes this QuoteItemDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteItemDetailCopyWith<QuoteItemDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteItemDetailCopyWith<$Res> {
  factory $QuoteItemDetailCopyWith(
          QuoteItemDetail value, $Res Function(QuoteItemDetail) then) =
      _$QuoteItemDetailCopyWithImpl<$Res, QuoteItemDetail>;
  @useResult
  $Res call(
      {String id,
      String description,
      double quantity,
      String unit,
      double unitPrice,
      double total,
      String? photoUrl,
      String? productId,
      int sortOrder,
      Map<String, dynamic> customFields});
}

/// @nodoc
class _$QuoteItemDetailCopyWithImpl<$Res, $Val extends QuoteItemDetail>
    implements $QuoteItemDetailCopyWith<$Res> {
  _$QuoteItemDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? total = null,
    Object? photoUrl = freezed,
    Object? productId = freezed,
    Object? sortOrder = null,
    Object? customFields = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      customFields: null == customFields
          ? _value.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteItemDetailImplCopyWith<$Res>
    implements $QuoteItemDetailCopyWith<$Res> {
  factory _$$QuoteItemDetailImplCopyWith(_$QuoteItemDetailImpl value,
          $Res Function(_$QuoteItemDetailImpl) then) =
      __$$QuoteItemDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      double quantity,
      String unit,
      double unitPrice,
      double total,
      String? photoUrl,
      String? productId,
      int sortOrder,
      Map<String, dynamic> customFields});
}

/// @nodoc
class __$$QuoteItemDetailImplCopyWithImpl<$Res>
    extends _$QuoteItemDetailCopyWithImpl<$Res, _$QuoteItemDetailImpl>
    implements _$$QuoteItemDetailImplCopyWith<$Res> {
  __$$QuoteItemDetailImplCopyWithImpl(
      _$QuoteItemDetailImpl _value, $Res Function(_$QuoteItemDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? total = null,
    Object? photoUrl = freezed,
    Object? productId = freezed,
    Object? sortOrder = null,
    Object? customFields = null,
  }) {
    return _then(_$QuoteItemDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      customFields: null == customFields
          ? _value._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteItemDetailImpl implements _QuoteItemDetail {
  const _$QuoteItemDetailImpl(
      {required this.id,
      required this.description,
      required this.quantity,
      required this.unit,
      required this.unitPrice,
      required this.total,
      this.photoUrl,
      this.productId,
      required this.sortOrder,
      required final Map<String, dynamic> customFields})
      : _customFields = customFields;

  factory _$QuoteItemDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteItemDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final double unitPrice;
  @override
  final double total;
  @override
  final String? photoUrl;
  @override
  final String? productId;
  @override
  final int sortOrder;
  final Map<String, dynamic> _customFields;
  @override
  Map<String, dynamic> get customFields {
    if (_customFields is EqualUnmodifiableMapView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_customFields);
  }

  @override
  String toString() {
    return 'QuoteItemDetail(id: $id, description: $description, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, total: $total, photoUrl: $photoUrl, productId: $productId, sortOrder: $sortOrder, customFields: $customFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteItemDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      quantity,
      unit,
      unitPrice,
      total,
      photoUrl,
      productId,
      sortOrder,
      const DeepCollectionEquality().hash(_customFields));

  /// Create a copy of QuoteItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteItemDetailImplCopyWith<_$QuoteItemDetailImpl> get copyWith =>
      __$$QuoteItemDetailImplCopyWithImpl<_$QuoteItemDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteItemDetailImplToJson(
      this,
    );
  }
}

abstract class _QuoteItemDetail implements QuoteItemDetail {
  const factory _QuoteItemDetail(
          {required final String id,
          required final String description,
          required final double quantity,
          required final String unit,
          required final double unitPrice,
          required final double total,
          final String? photoUrl,
          final String? productId,
          required final int sortOrder,
          required final Map<String, dynamic> customFields}) =
      _$QuoteItemDetailImpl;

  factory _QuoteItemDetail.fromJson(Map<String, dynamic> json) =
      _$QuoteItemDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  double get unitPrice;
  @override
  double get total;
  @override
  String? get photoUrl;
  @override
  String? get productId;
  @override
  int get sortOrder;
  @override
  Map<String, dynamic> get customFields;

  /// Create a copy of QuoteItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteItemDetailImplCopyWith<_$QuoteItemDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
