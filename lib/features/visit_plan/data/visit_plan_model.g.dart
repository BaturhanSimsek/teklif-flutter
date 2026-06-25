// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitPlanImpl _$$VisitPlanImplFromJson(Map<String, dynamic> json) =>
    _$VisitPlanImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerAddress: json['customerAddress'] as String,
      plannedAt: DateTime.parse(json['plannedAt'] as String),
      notes: json['notes'] as String?,
      status: (json['status'] as num).toInt(),
      outcome: json['outcome'] as String?,
    );

Map<String, dynamic> _$$VisitPlanImplToJson(_$VisitPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerAddress': instance.customerAddress,
      'plannedAt': instance.plannedAt.toIso8601String(),
      'notes': instance.notes,
      'status': instance.status,
      'outcome': instance.outcome,
    };
