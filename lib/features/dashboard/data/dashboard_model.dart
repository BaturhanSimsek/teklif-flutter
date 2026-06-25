import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required int totalQuotes,
    required int pendingQuotes,
    required int approvedQuotes,
    required int todayVisits,
    required List<RecentQuote> recentQuotes,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
class RecentQuote with _$RecentQuote {
  const factory RecentQuote({
    required String   id,
    required String   quoteNumber,
    required String   customerName,
    required int      status,
    required DateTime date,
    required String   currency,
  }) = _RecentQuote;

  factory RecentQuote.fromJson(Map<String, dynamic> json) =>
      _$RecentQuoteFromJson(json);
}
