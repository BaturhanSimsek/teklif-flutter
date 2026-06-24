// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$CreateUserResultImpl _$$CreateUserResultImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserResultImpl(
      userId: json['userId'] as String,
      tempPassword: json['tempPassword'] as String,
    );

Map<String, dynamic> _$$CreateUserResultImplToJson(
        _$CreateUserResultImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'tempPassword': instance.tempPassword,
    };
