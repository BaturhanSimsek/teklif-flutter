// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportsDataImpl _$$ReportsDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportsDataImpl(
      totalQuotes: (json['totalQuotes'] as num).toInt(),
      approvedQuotes: (json['approvedQuotes'] as num).toInt(),
      pendingQuotes: (json['pendingQuotes'] as num).toInt(),
      totalRevenueTry: (json['totalRevenueTry'] as num).toDouble(),
      monthlyRevenueTry: (json['monthlyRevenueTry'] as num).toDouble(),
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      newCustomersThisMonth: (json['newCustomersThisMonth'] as num).toInt(),
      monthlySales: (json['monthlySales'] as List<dynamic>)
          .map((e) => MonthlyStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReportsDataImplToJson(_$ReportsDataImpl instance) =>
    <String, dynamic>{
      'totalQuotes': instance.totalQuotes,
      'approvedQuotes': instance.approvedQuotes,
      'pendingQuotes': instance.pendingQuotes,
      'totalRevenueTry': instance.totalRevenueTry,
      'monthlyRevenueTry': instance.monthlyRevenueTry,
      'totalCustomers': instance.totalCustomers,
      'newCustomersThisMonth': instance.newCustomersThisMonth,
      'monthlySales': instance.monthlySales,
    };

_$MonthlyStatImpl _$$MonthlyStatImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyStatImpl(
      month: json['month'] as String,
      count: (json['count'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$MonthlyStatImplToJson(_$MonthlyStatImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'count': instance.count,
      'revenue': instance.revenue,
    };
