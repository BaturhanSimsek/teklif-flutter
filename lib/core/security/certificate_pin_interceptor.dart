import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// CERT_PIN dart-define ile saglanirsa SHA-256 pinning aktif olur.
/// Gelistirme ortaminda (kDebugMode veya pin bos) pinning atlanir.
///
/// Kullanim:
///   flutter build apk --dart-define=CERT_PIN="AA:BB:CC:..."
///   openssl s_client -connect api.firmam.com:443 < /dev/null 2>/dev/null \
///     | openssl x509 -fingerprint -sha256 -noout | cut -d= -f2
void applyPinning(Dio dio) {
  const pin = AppConstants.certPin;
  if (kDebugMode || pin.isEmpty) return;

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Sertifika DER baytlarinin SHA-256 ozeti hesaplanir, HEX formatinda pin ile karsilastirilir.
      final digest = sha256.convert(cert.der).bytes;
      final hexPin = digest
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join(':')
          .toUpperCase();
      return hexPin == pin.toUpperCase();
    };
    return client;
  };
}
