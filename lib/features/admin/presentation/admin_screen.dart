import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';

final _usersProvider = FutureProvider.autoDispose<List<AppUser>>((ref) =>
    ref.watch(userRepositoryProvider).getAll());

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_usersProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Yönetim Paneli'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.person_add),
            tooltip: 'Kullanıcı Ekle',
            onPressed: () => _showAddUserSheet(context, ref),
          ),
        ],
      ),
      body: async.when(
        data: (users) => _UserList(users: users, ref: ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }

  Future<void> _showAddUserSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddUserSheet(onCreated: () {
        ref.invalidate(_usersProvider);
      }),
    );
  }
}

// ── Kullanıcı Listesi ────────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  const _UserList({required this.users, required this.ref});
  final List<AppUser> users;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.group, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Henüz kullanıcı yok', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _UserCard(user: users[i], ref: ref),
    );
  }
}

// ── Kullanıcı Kartı ──────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.ref});
  final AppUser user;
  final WidgetRef ref;

  static const _roleLabels = {
    'Admin':   ('Yönetici',     Color(0xFF7B1FA2)),
    'Manager': ('Müdür',        Color(0xFF1565C0)),
    'Sales':   ('Satış Temsilcisi', Color(0xFF2E7D32)),
  };

  Color get _avatarColor {
    final colors = [
      const Color(0xFF1565C0), const Color(0xFF2E7D32),
      const Color(0xFF7B1FA2), const Color(0xFFE65100),
    ];
    return colors[user.fullName.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final (roleLabel, roleColor) = _roleLabels[user.role] ?? ('Bilinmiyor', Colors.grey);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _avatarColor,
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: user.isActive ? null : Colors.grey,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                roleLabel,
                style: TextStyle(fontSize: 11, color: roleColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email, style: const TextStyle(fontSize: 13)),
            if (!user.isActive) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pasif',
                  style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Symbols.more_vert, size: 20),
          onSelected: (v) => _onAction(context, v),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(children: [
                Icon(
                  user.isActive ? Symbols.person_off : Symbols.person_check,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(user.isActive ? 'Pasife Al' : 'Aktif Et'),
              ]),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'role_admin',
              child: Text('Yönetici Yap'),
            ),
            const PopupMenuItem(
              value: 'role_manager',
              child: Text('Müdür Yap'),
            ),
            const PopupMenuItem(
              value: 'role_sales',
              child: Text('Satış Temsilcisi Yap'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAction(BuildContext context, String action) async {
    final repo = ref.read(userRepositoryProvider);
    try {
      if (action == 'toggle') {
        final confirm = await _confirm(
          context,
          user.isActive
              ? '${user.fullName} kullanıcısını pasife almak istiyor musunuz?\nGiriş yapamaz hale gelecek.'
              : '${user.fullName} kullanıcısını tekrar aktif etmek istiyor musunuz?',
        );
        if (!confirm) return;
        await repo.toggleActive(user.id);
      } else if (action.startsWith('role_')) {
        final roleMap = {'role_admin': 'Admin', 'role_manager': 'Manager', 'role_sales': 'Sales'};
        await repo.changeRole(user.id, roleMap[action]!);
      }
      ref.invalidate(_usersProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<bool> _confirm(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Emin misiniz?'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Evet'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// ── Kullanıcı Ekleme Sheet ───────────────────────────────────────────────────

class _AddUserSheet extends StatefulWidget {
  const _AddUserSheet({required this.onCreated});
  final VoidCallback onCreated;

  @override
  State<_AddUserSheet> createState() => _AddUserSheetState();
}

class _AddUserSheetState extends State<_AddUserSheet> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String  _role    = 'Sales';
  bool    _loading = false;
  String? _generatedPassword;

  static const _roles = [
    ('Sales',   'Satış Temsilcisi'),
    ('Manager', 'Müdür'),
    ('Admin',   'Yönetici'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: _generatedPassword != null
          ? _SuccessView(
              email:    _emailCtrl.text,
              password: _generatedPassword!,
              onDone: () {
                widget.onCreated();
                Navigator.pop(context);
              },
            )
          : _FormView(
              formKey:  _formKey,
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              role:     _role,
              roles:    _roles,
              loading:  _loading,
              onRoleChanged: (r) => setState(() => _role = r),
              onSubmit: _submit,
            ),
    );
  }

  Future<void> _submit(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final result = await ref.read(userRepositoryProvider).create(
            fullName: _nameCtrl.text.trim(),
            email:    _emailCtrl.text.trim(),
            role:     _role,
          );
      setState(() {
        _loading           = false;
        _generatedPassword = result.tempPassword;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

class _FormView extends ConsumerWidget {
  const _FormView({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.role,
    required this.roles,
    required this.loading,
    required this.onRoleChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl;
  final String role;
  final List<(String, String)> roles;
  final bool loading;
  final void Function(String) onRoleChanged;
  final Future<void> Function(WidgetRef) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Yeni Kullanıcı Ekle',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              prefixIcon: Icon(Symbols.person),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailCtrl,
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
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: role,
            decoration: const InputDecoration(
              labelText: 'Rol',
              prefixIcon: Icon(Symbols.badge),
            ),
            items: roles
                .map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$2)))
                .toList(),
            onChanged: (v) => onRoleChanged(v!),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: loading ? null : () => onSubmit(ref),
            child: loading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Kullanıcı Oluştur'),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.email,
    required this.password,
    required this.onDone,
  });
  final String email, password;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Symbols.check_circle, size: 56, color: Color(0xFF2E7D32), fill: 1),
        const SizedBox(height: 16),
        const Text(
          'Kullanıcı Oluşturuldu!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bu bilgileri personele iletin:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        _InfoBox(label: 'E-posta', value: email),
        const SizedBox(height: 8),
        _InfoBox(label: 'Geçici Şifre', value: password, copyable: true),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Personel ilk girişte şifresini değiştirmesi gerekecek.',
            style: TextStyle(fontSize: 12, color: Color(0xFFE65100)),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onDone,
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.label, required this.value, this.copyable = false});
  final String label, value;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          if (copyable)
            IconButton(
              icon: const Icon(Symbols.content_copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Şifre kopyalandı')),
                );
              },
            ),
        ],
      ),
    );
  }
}
