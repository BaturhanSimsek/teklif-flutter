import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_model.freezed.dart';
part 'tenant_model.g.dart';

@freezed
class TenantSettings with _$TenantSettings {
  const factory TenantSettings({
    required String   id,
    required String   companyName,
    required String   slug,
    required bool     isActive,
    String? companyLegalName,
    String? city,
    String? phone,
    String? email,
    String? logoUrl,
    String? taxNumber,
    String? taxOffice,
    String? address,
    required DateTime createdAt,
  }) = _TenantSettings;

  factory TenantSettings.fromJson(Map<String, dynamic> json) =>
      _$TenantSettingsFromJson(json);
}
