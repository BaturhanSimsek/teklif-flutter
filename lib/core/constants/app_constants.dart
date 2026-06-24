import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  // Production build: flutter build apk --dart-define=API_URL=https://api.firmam.com/api/v1
  static const String _definedUrl = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_definedUrl.isNotEmpty) return _definedUrl;
    if (kIsWeb) return 'http://localhost:5074/api/v1';
    // Android emülatör → host makinesi
    return 'http://10.0.2.2:5074/api/v1';
  }

  // Üretimde sertifika parmak izi: openssl x509 -fingerprint -sha256 -in cert.pem
  // dart-define: flutter build apk --dart-define=CERT_PIN=AA:BB:CC:...
  static const String certPin = String.fromEnvironment('CERT_PIN');

  static const String tokenKey        = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tenantIdKey     = 'tenant_id';
  static const String userEmailKey    = 'user_email';
  static const String userRoleKey          = 'user_role';
  static const String userIdKey            = 'user_id';
  static const String mustChangePasswordKey = 'must_change_password';
}
