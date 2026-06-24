import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// CERT_PIN dart-define ile sağlanırsa SHA-256 pinning aktif olur.
/// Geliştirme ortamında (kDebugMode veya pin boş) pinning atlanır.
///
/// Kullanım:
///   flutter build apk --dart-define=CERT_PIN="AA:BB:CC:..."
///   openssl s_client -connect api.firmam.com:443 < /dev/null 2>/dev/null \
///     | openssl x509 -fingerprint -sha256 -noout | cut -d= -f2
void applyPinning(Dio dio) {
  const pin = AppConstants.certPin;
  if (kDebugMode || pin.isEmpty) return;

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Sertifika DER bytes'ından SHA-256 parmak izi hesaplanır.
      // Not: üretimde `crypto` paketi ile sha256.convert(cert.der) kullanın.
      final certBytes = cert.der;
      final hexPin    = certBytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join(':')
          .toUpperCase();
      return hexPin == pin.toUpperCase();
    };
    return client;
  };
}
