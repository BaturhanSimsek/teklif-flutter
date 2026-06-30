// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userId: json['userId'] as String,
      tenantId: json['tenantId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      mustChangePassword: json['mustChangePassword'] as bool? ?? false,
      twoFactorRequired: json['twoFactorRequired'] as bool? ?? false,
      twoFactorToken: json['twoFactorToken'] as String?,
      deletionCancelled: json['deletionCancelled'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'userId': instance.userId,
      'tenantId': instance.tenantId,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'mustChangePassword': instance.mustChangePassword,
      'twoFactorRequired': instance.twoFactorRequired,
      'twoFactorToken': instance.twoFactorToken,
      'deletionCancelled': instance.deletionCancelled,
    };
