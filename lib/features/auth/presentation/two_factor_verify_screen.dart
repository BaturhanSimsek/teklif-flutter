import '../../../core/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/notifications/notification_service.dart';
import '../data/auth_model.dart';

class TwoFactorVerifyScreen extends ConsumerStatefulWidget {
  final String twoFactorToken;
  const TwoFactorVerifyScreen({super.key, required this.twoFactorToken});

  @override
  ConsumerState<TwoFactorVerifyScreen> createState() => _TwoFactorVerifyScreenState();
}

class _TwoFactorVerifyScreenState extends ConsumerState<TwoFactorVerifyScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading   = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) return;

    setState(() => _loading = true);
    try {
      final dio = ref.read(authDioProvider);
      final res = await dio.post('/2fa/verify', data: {
        'twoFactorToken': widget.twoFactorToken,
        'code':           code,
      });

      final response = LoginResponse.fromJson(res.data as Map<String, dynamic>);
      const storage  = FlutterSecureStorage();

      await storage.write(key: AppConstants.tokenKey,              value: response.accessToken);
      await storage.write(key: AppConstants.refreshTokenKey,       value: response.refreshToken);
      await storage.write(key: AppConstants.tenantIdKey,           value: response.tenantId);
      await storage.write(key: AppConstants.userEmailKey,          value: response.email);
      await storage.write(key: AppConstants.userRoleKey,           value: response.role);
      await storage.write(key: AppConstants.userIdKey,             value: response.userId);
      await storage.write(key: AppConstants.mustChangePasswordKey, value: response.mustChangePassword.toString());

      // Başarılı 2FA dogrulamasi → FCM token'ı kaydet (normal login akisinda da yapiliyor)
      ref.read(notificationServiceProvider)
          .requestPermissionAndRegisterToken()
          .ignore();

      if (mounted && response.deletionCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Hesap silme talebiniz iptal edildi, tekrar hoş geldiniz!'),
          backgroundColor: AppColors.success,
        ));
      }

      if (mounted) context.go('/dashboard');
    } on DioException catch (e) {
      final msg = ApiException.fromDio(e).message;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İki Faktörlü Doğrulama')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.security, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Kimlik Doğrulama Uygulamasındaki 6 Haneli Kodu Girin',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 12),
              decoration: const InputDecoration(
                hintText: '000000',
                counterText: '',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) { if (v.length == 6) _verify(); },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Doğrula'),
            ),
          ],
        ),
      ),
    );
  }
}
