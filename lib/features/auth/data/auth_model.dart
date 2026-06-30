import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String   accessToken,
    required String   refreshToken,
    required DateTime expiresAt,
    required String   userId,
    required String   tenantId,
    required String   fullName,
    required String   email,
    required String   role,
    @Default(false) bool    mustChangePassword,
    @Default(false) bool    twoFactorRequired,
    String?                 twoFactorToken,
    @Default(false) bool    deletionCancelled,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
