// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      name: json['name'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      notes: json['notes'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'name': instance.name,
      'purchasePrice': instance.purchasePrice,
      'salePrice': instance.salePrice,
      'notes': instance.notes,
      'photoUrl': instance.photoUrl,
      'isActive': instance.isActive,
    };
