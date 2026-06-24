import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
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

  Future<String> _downloadToTemp(String quoteId, String quoteNumber) async {
    final dir  = await getTemporaryDirectory();
    final path = '${dir.path}/teklif-$quoteNumber.pdf';
    await _dio.download(
      '/quotes/$quoteId/pdf',
      path,
      options: Options(responseType: ResponseType.bytes),
    );
    return path;
  }

  Future<void> downloadAndOpen(String quoteId, String quoteNumber) async {
    if (kIsWeb) {
      final url = '${AppConstants.baseUrl}/quotes/$quoteId/pdf';
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return;
    }
    final path = await _downloadToTemp(quoteId, quoteNumber);
    await OpenFilex.open(path);
  }

  Future<void> downloadAndShare(String quoteId, String quoteNumber) async {
    if (kIsWeb) {
      final url = '${AppConstants.baseUrl}/quotes/$quoteId/pdf';
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return;
    }
    final path = await _downloadToTemp(quoteId, quoteNumber);
    await Share.shareXFiles(
      [XFile(path, mimeType: 'application/pdf')],
      subject: 'Teklif $quoteNumber',
    );
  }
}
