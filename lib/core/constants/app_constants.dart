import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5074/api/v1';
    // Android emülatör → host makinesi
    return 'http://10.0.2.2:5074/api/v1';
  }

  static const String tokenKey        = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tenantIdKey     = 'tenant_id';
  static const String userEmailKey    = 'user_email';
  static const String userRoleKey          = 'user_role';
  static const String userIdKey            = 'user_id';
  static const String mustChangePasswordKey = 'must_change_password';
}
