// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      totalQuotes: (json['totalQuotes'] as num).toInt(),
      pendingQuotes: (json['pendingQuotes'] as num).toInt(),
      approvedQuotes: (json['approvedQuotes'] as num).toInt(),
      todayVisits: (json['todayVisits'] as num).toInt(),
      recentQuotes: (json['recentQuotes'] as List<dynamic>)
          .map((e) => RecentQuote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'totalQuotes': instance.totalQuotes,
      'pendingQuotes': instance.pendingQuotes,
      'approvedQuotes': instance.approvedQuotes,
      'todayVisits': instance.todayVisits,
      'recentQuotes': instance.recentQuotes,
    };

_$RecentQuoteImpl _$$RecentQuoteImplFromJson(Map<String, dynamic> json) =>
    _$RecentQuoteImpl(
      id: json['id'] as String,
      quoteNumber: json['quoteNumber'] as String,
      customerName: json['customerName'] as String,
      status: (json['status'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$$RecentQuoteImplToJson(_$RecentQuoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quoteNumber': instance.quoteNumber,
      'customerName': instance.customerName,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
      'currency': instance.currency,
    };
