// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      totalQuotes: (json['totalQuotes'] as num).toInt(),
      approvedQuotes: (json['approvedQuotes'] as num).toInt(),
      pendingQuotes: (json['pendingQuotes'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      newCustomersThisMonth: (json['newCustomersThisMonth'] as num).toInt(),
      monthlySales: (json['monthlySales'] as List<dynamic>)
          .map((e) => MonthlyStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'totalQuotes': instance.totalQuotes,
      'approvedQuotes': instance.approvedQuotes,
      'pendingQuotes': instance.pendingQuotes,
      'totalRevenue': instance.totalRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
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
