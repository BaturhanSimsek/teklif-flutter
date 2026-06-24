import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String   id,
    required String   fullName,
    required String   email,
    required String   role,
    required bool     isActive,
    required DateTime createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

@freezed
class CreateUserResult with _$CreateUserResult {
  const factory CreateUserResult({
    required String userId,
    required String tempPassword,
  }) = _CreateUserResult;

  factory CreateUserResult.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResultFromJson(json);
}
