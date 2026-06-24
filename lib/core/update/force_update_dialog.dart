import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({
    super.key,
    required this.message,
    required this.updateUrl,
    required this.isForced,
  });

  final String message;
  final String updateUrl;
  final bool   isForced;

  static Future<void> show(BuildContext ctx,
      {required String message,
      required String updateUrl,
      required bool isForced}) {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: !isForced,
      builder: (_) => ForceUpdateDialog(
          message: message, updateUrl: updateUrl, isForced: isForced),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isForced ? 'Güncelleme Gerekli' : 'Yeni Sürüm Mevcut'),
      content: Text(message.isNotEmpty
          ? message
          : isForced
              ? 'Uygulamayı kullanmaya devam etmek için lütfen güncelleyin.'
              : 'Yeni bir sürüm yayınlandı. Güncellemek ister misiniz?'),
      actions: [
        if (!isForced)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Daha Sonra'),
          ),
        FilledButton(
          onPressed: () async {
            final uri = Uri.tryParse(updateUrl);
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: const Text('Güncelle'),
        ),
      ],
    );
  }
}
