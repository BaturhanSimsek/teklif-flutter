import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_plan_model.freezed.dart';
part 'visit_plan_model.g.dart';

@freezed
class VisitPlan with _$VisitPlan {
  const factory VisitPlan({
    required String   id,
    required String   customerId,
    required String   customerName,
    required String   customerPhone,
    required String   customerAddress,
    required DateTime plannedAt,
    String? notes,
    required int      status,
    String? outcome,
  }) = _VisitPlan;

  factory VisitPlan.fromJson(Map<String, dynamic> json) =>
      _$VisitPlanFromJson(json);
}
