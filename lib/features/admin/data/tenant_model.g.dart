// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantSettingsImpl _$$TenantSettingsImplFromJson(Map<String, dynamic> json) =>
    _$TenantSettingsImpl(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      slug: json['slug'] as String,
      isActive: json['isActive'] as bool,
      companyLegalName: json['companyLegalName'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      logoUrl: json['logoUrl'] as String?,
      taxNumber: json['taxNumber'] as String?,
      taxOffice: json['taxOffice'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TenantSettingsImplToJson(
        _$TenantSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'slug': instance.slug,
      'isActive': instance.isActive,
      'companyLegalName': instance.companyLegalName,
      'city': instance.city,
      'phone': instance.phone,
      'email': instance.email,
      'logoUrl': instance.logoUrl,
      'taxNumber': instance.taxNumber,
      'taxOffice': instance.taxOffice,
      'address': instance.address,
      'createdAt': instance.createdAt.toIso8601String(),
    };
