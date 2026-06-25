import 'package:freezed_annotation/freezed_annotation.dart';

part 'reports_model.freezed.dart';
part 'reports_model.g.dart';

@freezed
class ReportsData with _$ReportsData {
  const factory ReportsData({
    required int    totalQuotes,
    required int    approvedQuotes,
    required int    pendingQuotes,
    required double totalRevenueTry,
    required double monthlyRevenueTry,
    required int    totalCustomers,
    required int    newCustomersThisMonth,
    required List<MonthlyStat> monthlySales,
  }) = _ReportsData;

  factory ReportsData.fromJson(Map<String, dynamic> json) =>
      _$ReportsDataFromJson(json);
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
