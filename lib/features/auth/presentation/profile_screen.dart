import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../data/auth_repository.dart';
import 'change_password_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  bool  _loading   = false;
  bool  _loaded    = false;
  String _email    = '';
  String _role     = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('/profile');
      final data = res.data as Map<String, dynamic>;
      setState(() {
        _nameCtrl.text = data['fullName'] as String? ?? '';
        _email         = data['email']    as String? ?? '';
        _role          = data['role']     as String? ?? '';
        _loaded        = true;
      });
    } catch (_) {
      setState(() => _loaded = true);
    }
  }

  Future<void> _saveName() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/profile', data: {'fullName': _nameCtrl.text.trim()});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil güncellendi.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Oturumunuzu kapatmak istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(authRepositoryProvider).logout();
    if (mounted) context.go('/login');
  }

  static const _roleLabels = {
    'Admin':   'Yönetici',
    'Manager': 'Müdür',
    'Sales':   'Satış Temsilcisi',
  };

  Color get _roleColor {
    switch (_role) {
      case 'Admin':   return const Color(0xFF7B1FA2);
      case 'Manager': return const Color(0xFF1565C0);
      default:        return const Color(0xFF2E7D32);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: false,
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Avatar
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: primary,
                        child: Text(
                          _nameCtrl.text.isNotEmpty
                              ? _nameCtrl.text[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: _roleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _roleLabels[_role] ?? _role,
                          style: TextStyle(
                              color: _roleColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_email,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Ad güncelle
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Icon(Symbols.person, size: 16, color: primary),
                          const SizedBox(width: 8),
                          Text('Profil Bilgileri',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: primary)),
                        ]),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Ad Soyad',
                            prefixIcon: Icon(Symbols.badge),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Zorunlu alan'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _loading ? null : _saveName,
                          icon: _loading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Symbols.save, size: 18),
                          label: const Text('Güncelle'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Şifre değiştir
                _ActionTile(
                  icon: Symbols.lock_reset,
                  label: 'Şifre Değiştir',
                  color: primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen()),
                  ),
                ),
                const SizedBox(height: 8),

                // Çıkış
                _ActionTile(
                  icon: Symbols.logout,
                  label: 'Çıkış Yap',
                  color: Colors.red,
                  onTap: _logout,
                ),
              ],
            ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String   label;
  final Color    color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Text(label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: color)),
            const Spacer(),
            Icon(Symbols.chevron_right, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}
