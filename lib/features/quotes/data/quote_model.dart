import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

@freezed
class QuoteSummary with _$QuoteSummary {
  const factory QuoteSummary({
    required String id,
    required String quoteNumber,
    required String quoteNumberDisplay,
    required int revisionNo,
    required int status,
    required bool isApproved,
    required String formTemplateName,
    required String currency,
    required String language,
    required double grandTotal,
    required String createdByEmail,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _QuoteSummary;

  factory QuoteSummary.fromJson(Map<String, dynamic> json) =>
      _$QuoteSummaryFromJson(json);
}

@freezed
class QuoteDetail with _$QuoteDetail {
  const factory QuoteDetail({
    required String id,
    required String quoteNumber,
    required String quoteNumberDisplay,
    required int revisionNo,
    required int status,
    required bool isApproved,
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String formTemplateId,
    required String formTemplateName,
    required String language,
    required String currency,
    required DateTime date,
    required String paymentTerm,
    required String deliveryDays,
    required double kdvRate,
    required double discountRate,
    String? notes,
    required double subTotal,
    required double discountAmount,
    required double kdvAmount,
    required double grandTotal,
    required String createdByEmail,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? shareToken,
    @Default(0) int viewCount,
    DateTime? viewedAt,
    String? signatureBase64,
    @Default(false) bool hasSignedDocument,
    required List<QuoteItemDetail> items,
  }) = _QuoteDetail;

  factory QuoteDetail.fromJson(Map<String, dynamic> json) =>
      _$QuoteDetailFromJson(json);
}

@freezed
class QuoteItemDetail with _$QuoteItemDetail {
  const factory QuoteItemDetail({
    required String id,
    required String description,
    required double quantity,
    required String unit,
    required double unitPrice,
    required double total,
    String? photoUrl,
    String? productId,
    required int sortOrder,
    required Map<String, dynamic> customFields,
  }) = _QuoteItemDetail;

  factory QuoteItemDetail.fromJson(Map<String, dynamic> json) =>
      _$QuoteItemDetailFromJson(json);
}
