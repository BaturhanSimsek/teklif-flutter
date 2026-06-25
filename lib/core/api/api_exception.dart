import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int?   statusCode;
  final String message;
  final Map<String, List<String>>? validationErrors;

  const ApiException({
    this.statusCode,
    required this.message,
    this.validationErrors,
  });

  factory ApiException.fromDio(DioException e) {
    final response = e.response;

    if (response == null) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout     ||
        DioExceptionType.receiveTimeout  => const ApiException(
            message: 'Sunucu yanıt vermedi. Lütfen tekrar deneyin.',
          ),
        DioExceptionType.connectionError => const ApiException(
            message: 'Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.',
          ),
        _ => ApiException(
            message: 'Bağlantı hatası: ${e.message ?? 'Bilinmeyen hata'}',
          ),
      };
    }

    final statusCode = response.statusCode;
    final data = response.data;
    String msg;
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      // Try validation errors first (ASP.NET Core ValidationProblemDetails)
      if (data['errors'] is Map) {
        errors = (data['errors'] as Map).map(
          (k, v) => MapEntry(k as String, (v as List).cast<String>()),
        );
        msg = errors.values.expand((e) => e).join('\n');
      } else {
        // Try common error message fields in order of preference
        msg = data['detail'] as String?
            ?? data['message'] as String?
            ?? data['error'] as String?
            ?? data['title'] as String?
            ?? _statusMessage(statusCode);
      }
    } else if (data is String && data.isNotEmpty && !data.trimLeft().startsWith('<')) {
      // Plain-text response (not HTML)
      msg = data;
    } else {
      msg = _statusMessage(statusCode);
    }

    return ApiException(
      statusCode:       statusCode,
      message:          msg,
      validationErrors: errors,
    );
  }

  static String _statusMessage(int? code) => switch (code) {
    400 => 'Geçersiz istek. Girilen bilgileri kontrol edin.',
    401 => 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.',
    403 => 'Bu işlem için yetkiniz bulunmuyor.',
    404 => 'İstenen kaynak bulunamadı.',
    409 => 'Bu kayıt zaten mevcut.',
    422 => 'Gönderilen veriler geçersiz.',
    429 => 'Çok fazla istek gönderildi. Lütfen bekleyin.',
    500 => 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.',
    503 => 'Servis geçici olarak kullanılamıyor.',
    _   => 'Beklenmeyen hata (HTTP ${code ?? '?'}).',
  };

  String get userMessage => message;

  @override
  String toString() => statusCode != null ? '[$statusCode] $message' : message;
}
