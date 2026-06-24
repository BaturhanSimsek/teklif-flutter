// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteSummaryImpl _$$QuoteSummaryImplFromJson(Map<String, dynamic> json) =>
    _$QuoteSummaryImpl(
      id: json['id'] as String,
      quoteNumber: json['quoteNumber'] as String,
      quoteNumberDisplay: json['quoteNumberDisplay'] as String,
      revisionNo: (json['revisionNo'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      isApproved: json['isApproved'] as bool,
      formTemplateName: json['formTemplateName'] as String,
      currency: json['currency'] as String,
      language: json['language'] as String,
      grandTotal: (json['grandTotal'] as num).toDouble(),
      createdByEmail: json['createdByEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$QuoteSummaryImplToJson(_$QuoteSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quoteNumber': instance.quoteNumber,
      'quoteNumberDisplay': instance.quoteNumberDisplay,
      'revisionNo': instance.revisionNo,
      'status': instance.status,
      'isApproved': instance.isApproved,
      'formTemplateName': instance.formTemplateName,
      'currency': instance.currency,
      'language': instance.language,
      'grandTotal': instance.grandTotal,
      'createdByEmail': instance.createdByEmail,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$QuoteDetailImpl _$$QuoteDetailImplFromJson(Map<String, dynamic> json) =>
    _$QuoteDetailImpl(
      id: json['id'] as String,
      quoteNumber: json['quoteNumber'] as String,
      quoteNumberDisplay: json['quoteNumberDisplay'] as String,
      revisionNo: (json['revisionNo'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      isApproved: json['isApproved'] as bool,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      formTemplateId: json['formTemplateId'] as String,
      formTemplateName: json['formTemplateName'] as String,
      language: json['language'] as String,
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      paymentTerm: json['paymentTerm'] as String,
      deliveryDays: json['deliveryDays'] as String,
      kdvRate: (json['kdvRate'] as num).toDouble(),
      discountRate: (json['discountRate'] as num).toDouble(),
      notes: json['notes'] as String?,
      subTotal: (json['subTotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      kdvAmount: (json['kdvAmount'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      createdByEmail: json['createdByEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => QuoteItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuoteDetailImplToJson(_$QuoteDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quoteNumber': instance.quoteNumber,
      'quoteNumberDisplay': instance.quoteNumberDisplay,
      'revisionNo': instance.revisionNo,
      'status': instance.status,
      'isApproved': instance.isApproved,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'formTemplateId': instance.formTemplateId,
      'formTemplateName': instance.formTemplateName,
      'language': instance.language,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'paymentTerm': instance.paymentTerm,
      'deliveryDays': instance.deliveryDays,
      'kdvRate': instance.kdvRate,
      'discountRate': instance.discountRate,
      'notes': instance.notes,
      'subTotal': instance.subTotal,
      'discountAmount': instance.discountAmount,
      'kdvAmount': instance.kdvAmount,
      'grandTotal': instance.grandTotal,
      'createdByEmail': instance.createdByEmail,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

_$QuoteItemDetailImpl _$$QuoteItemDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$QuoteItemDetailImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String?,
      productId: json['productId'] as String?,
      sortOrder: (json['sortOrder'] as num).toInt(),
      customFields: json['customFields'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$QuoteItemDetailImplToJson(
        _$QuoteItemDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unitPrice': instance.unitPrice,
      'total': instance.total,
      'photoUrl': instance.photoUrl,
      'productId': instance.productId,
      'sortOrder': instance.sortOrder,
      'customFields': instance.customFields,
    };
