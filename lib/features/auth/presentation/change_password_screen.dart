import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key, this.forced = false});

  // forced=true → geçici şifreyle ilk girişte zorunlu
  final bool forced;

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading      = false;
  bool _showCurrent  = false;
  bool _showNew      = false;
  bool _showConfirm  = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/auth/change-password', data: {
        'currentPassword': _currentCtrl.text,
        'newPassword':     _newCtrl.text,
      });
      const storage = FlutterSecureStorage();
      await storage.write(key: AppConstants.mustChangePasswordKey, value: 'false');
      if (mounted) context.go('/quotes');
    } on DioException catch (e) {
      setState(() => _loading = false);
      final msg = e.response?.data?['detail'] ?? 'Bir hata oluştu.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
            expandedHeight: 160,
            pinned: true,
            automaticallyImplyLeading: !widget.forced,
            backgroundColor: primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary.withOpacity(0.85), primary],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Symbols.lock_reset, size: 32, color: Colors.white, fill: 1),
                        const SizedBox(height: 8),
                        Text(
                          widget.forced ? 'Şifrenizi Değiştirin' : 'Şifre Değiştir',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        if (widget.forced)
                          const Text(
                            'Güvenliğiniz için lütfen yeni bir şifre belirleyin.',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
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
                    if (widget.forced) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Symbols.info, size: 18, color: Color(0xFFE65100)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Hesabınız yönetici tarafından oluşturuldu. Devam etmek için yeni şifre belirleyin.',
                                style: TextStyle(fontSize: 13, color: Color(0xFFE65100)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    _PasswordField(
                      controller: _currentCtrl,
                      label: widget.forced ? 'Geçici Şifre' : 'Mevcut Şifre',
                      show: _showCurrent,
                      onToggle: () => setState(() => _showCurrent = !_showCurrent),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Zorunlu alan' : null,
                    ),
                    const SizedBox(height: 16),

                    _PasswordField(
                      controller: _newCtrl,
                      label: 'Yeni Şifre',
                      show: _showNew,
                      onToggle: () => setState(() => _showNew = !_showNew),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Zorunlu alan';
                        if (v.length < 6) return 'En az 6 karakter olmalı';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _PasswordField(
                      controller: _confirmCtrl,
                      label: 'Yeni Şifre (Tekrar)',
                      show: _showConfirm,
                      onToggle: () => setState(() => _showConfirm = !_showConfirm),
                      validator: (v) => v != _newCtrl.text ? 'Şifreler eşleşmiyor' : null,
                    ),
                    const SizedBox(height: 32),

                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Şifreyi Değiştir',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.show,
    required this.onToggle,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool show;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Symbols.lock),
        suffixIcon: IconButton(
          icon: Icon(show ? Symbols.visibility_off : Symbols.visibility),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }
}
