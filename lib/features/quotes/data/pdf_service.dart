import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';

part 'pdf_service.g.dart';

@riverpod
PdfService pdfService(PdfServiceRef ref) =>
    PdfService(ref.watch(dioProvider));

class PdfService {
  PdfService(this._dio);
  final Dio _dio;

  Future<void> downloadAndOpen(String quoteId, String quoteNumber) async {
    if (kIsWeb) {
      // Web: tarayıcıda aç
      final url = '${AppConstants.baseUrl}/quotes/$quoteId/pdf';
      final token = await _dio.options.headers['Authorization'];
      final uri = Uri.parse('$url?token=${token?.toString().replaceFirst('Bearer ', '')}');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    // Mobil: indir + aç
    final dir  = await getTemporaryDirectory();
    final path = '${dir.path}/teklif-$quoteNumber.pdf';

    await _dio.download(
      '/quotes/$quoteId/pdf',
      path,
      options: Options(responseType: ResponseType.bytes),
    );

    await OpenFilex.open(path);
  }
}
