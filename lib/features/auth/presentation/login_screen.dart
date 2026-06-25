import '../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/auth/biometric_service.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool _loading        = false;
  bool _obscure        = true;
  bool _biometricAvail = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final svc      = ref.read(biometricServiceProvider);
    final isLoggedIn = await ref.read(authRepositoryProvider).isLoggedIn();
    if (!isLoggedIn) return;

    final avail   = await svc.isAvailable();
    final enabled = await svc.isEnabled();
    if (avail) setState(() => _biometricAvail = true);

    if (avail && enabled && mounted) {
      final ok = await svc.authenticate();
      if (ok && mounted) context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _tryBiometric() async {
    HapticFeedback.mediumImpact();
    final ok = await ref.read(biometricServiceProvider).authenticate();
    if (ok && mounted) context.go('/dashboard');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final response = await ref.read(authRepositoryProvider).login(_email.text.trim(), _password.text);
      if (!mounted) return;

      if (response.twoFactorRequired && response.twoFactorToken != null) {
        context.push('/2fa-verify', extra: response.twoFactorToken);
      } else {
        // Başarılı login → FCM token'ı kaydet
        ref.read(notificationServiceProvider)
            .requestPermissionAndRegisterToken()
            .ignore();
        context.go('/dashboard');
      }
    } on Exception catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
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
    final primary = Theme.of(context).colorScheme.primary;
    final size    = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Üst gradient header
          Container(
            height: size.height * 0.38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(0.85),
                  primary,
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo alanı
                  SizedBox(
                    height: size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Symbols.description, size: 40, color: Colors.white, fill: 1),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'TeklifApp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Profesyonel Teklif Yönetimi',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form kartı
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giriş Yap',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hesabınıza giriş yapın',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          ),
                          const SizedBox(height: 28),

                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'E-posta',
                              hintText: 'ornek@firma.com',
                              prefixIcon: Icon(Symbols.mail, size: 20),
                            ),
                            validator: (v) =>
                                v == null || !v.contains('@') ? 'Geçerli e-posta girin' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _password,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              prefixIcon: const Icon(Symbols.lock, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure ? Symbols.visibility_off : Symbols.visibility,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) =>
                                v == null || v.length < 6 ? 'En az 6 karakter' : null,
                          ),
                          const SizedBox(height: 28),

                          AppButton(
                            label: 'Giriş Yap',
                            icon: Symbols.login,
                            isFullWidth: true,
                            height: 52,
                            loading: _loading,
                            onPressed: _submit,
                            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          if (_biometricAvail) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _tryBiometric,
                              icon: const Icon(Symbols.fingerprint, size: 20),
                              label: const Text('Biyometrik ile Giriş'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Firmanız kayıtlı değil mi?',
                                  style: TextStyle(color: Colors.grey, fontSize: 13)),
                              TextButton(
                                onPressed: () => context.go('/register'),
                                child: const Text('Ücretsiz Kaydol'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
