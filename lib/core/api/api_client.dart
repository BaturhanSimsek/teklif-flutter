import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/auth_notifier.dart';
import '../constants/app_constants.dart';
import '../security/certificate_pin_interceptor.dart';

part 'api_client.g.dart';

// AuthService icin ayri Dio — kimlik dogrulama, token refresh interceptor gereksiz
@riverpod
Dio authDio(AuthDioRef ref) {
  final d = Dio(BaseOptions(
    baseUrl: AppConstants.authServiceUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));
  applyPinning(d);
  return d;
}

// ReportingService icin ayri Dio — Authorization header'i ekler, raporlar/dashboard/audit
@riverpod
Dio reportingDio(ReportingDioRef ref) {
  const storage = FlutterSecureStorage();
  final d = Dio(BaseOptions(
    baseUrl: AppConstants.reportingServiceUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json'},
  ));
  applyPinning(d);
  d.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read(key: AppConstants.tokenKey);
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
    },
  ));
  return d;
}

@riverpod
Dio dio(DioRef ref) {
  const storage = FlutterSecureStorage();
  final authN   = ref.read(authNotifierProvider);

  final d = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  applyPinning(d);

  if (kDebugMode) {
    d.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('[API ERROR] ${error.requestOptions.method} '
            '${error.requestOptions.path} → '
            'HTTP ${error.response?.statusCode} | '
            'body: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  d.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read(key: AppConstants.tokenKey);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode != 401) {
        return handler.next(error);
      }

      // Sonsuz döngü engeli: refresh endpoint 401 dönerse çıkış yap
      if (error.requestOptions.baseUrl.contains('5076') ||
          error.requestOptions.path.contains('/auth/refresh')) {
        await storage.deleteAll();
        authN.invalidate();
        return handler.next(error);
      }

      final refreshToken = await storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) {
        await storage.deleteAll();
        authN.invalidate();
        return handler.next(error);
      }

      try {
        final refreshDio = Dio(BaseOptions(
          baseUrl: AppConstants.authServiceUrl,
          connectTimeout: const Duration(seconds: 10),
        ));
        applyPinning(refreshDio);
        final res = await refreshDio.post(
          '/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccess  = res.data['accessToken']  as String;
        final newRefresh = res.data['refreshToken'] as String;

        await storage.write(key: AppConstants.tokenKey,        value: newAccess);
        await storage.write(key: AppConstants.refreshTokenKey, value: newRefresh);

        // Orijinal isteği yeni token ile tekrar gönder
        final opts = error.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccess';
        final cloned = await d.fetch(opts);
        return handler.resolve(cloned);
      } catch (_) {
        await storage.deleteAll();
        authN.invalidate();
        return handler.next(error);
      }
    },
  ));

  return d;
}
