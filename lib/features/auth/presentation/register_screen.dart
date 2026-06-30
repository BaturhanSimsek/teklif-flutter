import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _companyCtrl  = TextEditingController();
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _passCtrl2    = TextEditingController();
  bool _showPass      = false;
  bool _loading       = false;

  @override
  void dispose() {
    _companyCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _passCtrl2.dispose();
    super.dispose();
  }

  String _toSlug(String name) =>
      name.toLowerCase().trim()
          .replaceAll(RegExp(r'[ğ]'), 'g')
          .replaceAll(RegExp(r'[üü]'), 'u')
          .replaceAll(RegExp(r'[şş]'), 's')
          .replaceAll(RegExp(r'[ıi]'), 'i')
          .replaceAll(RegExp(r'[öo]'), 'o')
          .replaceAll(RegExp(r'[çc]'), 'c')
          .replaceAll(RegExp(r'[^a-z0-9]'), '-')
          .replaceAll(RegExp(r'-+'), '-')
          .replaceAll(RegExp(r'^-|-$'), '');

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final dio = ref.read(dioProvider);
      final res = await dio.post('/tenants/register', data: {
        'companyName':   _companyCtrl.text.trim(),
        'slug':          _toSlug(_companyCtrl.text),
        'adminEmail':    _emailCtrl.text.trim(),
        'adminPassword': _passCtrl.text,
        'adminFullName': _nameCtrl.text.trim(),
      });

      const storage = FlutterSecureStorage();
      await storage.write(
          key: AppConstants.tokenKey, value: res.data['accessToken'] as String);
      await storage.write(
          key: AppConstants.userRoleKey, value: 'Admin');
      await storage.write(
          key: AppConstants.mustChangePasswordKey, value: 'false');

      if (mounted) context.go('/dashboard');
    } on DioException catch (e) {
      setState(() => _loading = false);
      final detail = e.response?.data?['detail'] ??
          e.response?.data?['errors']?.toString() ??
          'Bir hata oluştu.';
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(detail.toString())));
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Symbols.arrow_back),
              onPressed: () => context.go('/login'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary.withValues(alpha: 0.85), primary],
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Symbols.business, size: 32,
                            color: Colors.white, fill: 1),
                        SizedBox(height: 8),
                        Text('Firmayı Kaydet',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text('Ücretsiz başlayın, kredi kartı gerekmez.',
                            style: TextStyle(fontSize: 13, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Firma
                    Text('Firma Bilgileri',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: primary)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _companyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Firma / Ticari Adı',
                        prefixIcon: Icon(Symbols.business),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 24),

                    // Yetkili
                    Text('Yetkili Bilgileri',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: primary)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Ad Soyad',
                        prefixIcon: Icon(Symbols.person),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-posta',
                        prefixIcon: Icon(Symbols.mail),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Zorunlu alan';
                        if (!v.contains('@')) return 'Geçerli e-posta girin';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: !_showPass,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Symbols.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_showPass
                              ? Symbols.visibility_off
                              : Symbols.visibility),
                          onPressed: () =>
                              setState(() => _showPass = !_showPass),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Zorunlu alan';
                        if (v.length < 6) return 'En az 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passCtrl2,
                      obscureText: !_showPass,
                      decoration: const InputDecoration(
                        labelText: 'Şifre (Tekrar)',
                        prefixIcon: Icon(Symbols.lock),
                      ),
                      validator: (v) =>
                          v != _passCtrl.text ? 'Şifreler eşleşmiyor' : null,
                    ),
                    const SizedBox(height: 32),

                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _loading
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Hesap Oluştur',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Zaten hesabınız var mı?',
                            style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Giriş Yap'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
