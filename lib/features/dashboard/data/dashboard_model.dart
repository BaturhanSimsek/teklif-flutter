import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required int     totalQuotes,
    required int     approvedQuotes,
    required int     pendingQuotes,
    required double  totalRevenue,
    required double  monthlyRevenue,
    required int     totalCustomers,
    required int     newCustomersThisMonth,
    required List<MonthlyStat> monthlySales,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
class MonthlyStat with _$MonthlyStat {
  const factory MonthlyStat({
    required String month,
    required int    count,
    required double revenue,
  }) = _MonthlyStat;

  factory MonthlyStat.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatFromJson(json);
}
