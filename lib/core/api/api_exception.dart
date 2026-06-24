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
      return const ApiException(message: 'Sunucuya ulaşılamadı. İnternet bağlantınızı kontrol edin.');
    }

    final data = response.data;
    String msg = 'Bir hata oluştu.';
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      msg    = data['title'] as String? ?? msg;
      if (data['errors'] is Map) {
        errors = (data['errors'] as Map).map(
          (k, v) => MapEntry(k as String, (v as List).cast<String>()),
        );
        msg = errors.values.expand((e) => e).join('\n');
      }
    }

    return ApiException(
      statusCode:       response.statusCode,
      message:          msg,
      validationErrors: errors,
    );
  }

  @override
  String toString() => message;
}
