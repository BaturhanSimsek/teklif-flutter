import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/skeleton.dart';
import '../data/rep_location_model.dart';
import '../data/rep_location_repository.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';

final _usersProvider = FutureProvider.autoDispose<List<AppUser>>((ref) =>
    ref.watch(userRepositoryProvider).getAll());

final _locationsProvider = FutureProvider.autoDispose<List<RepLocation>>((ref) =>
    ref.watch(repLocationRepositoryProvider).getAll());

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetim Paneli'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.inventory_2),
            tooltip: 'Ürünler',
            onPressed: () => context.push('/admin/products'),
          ),
          IconButton(
            icon: const Icon(Symbols.category),
            tooltip: 'Kategoriler',
            onPressed: () => context.push('/admin/categories'),
          ),
          IconButton(
            icon: const Icon(Symbols.straighten),
            tooltip: 'Birimler',
            onPressed: () => context.push('/admin/units'),
          ),
          IconButton(
            icon: const Icon(Symbols.article),
            tooltip: 'Form Şablonları',
            onPressed: () => context.push('/admin/templates'),
          ),
          IconButton(
            icon: const Icon(Symbols.settings),
            tooltip: 'Firma Ayarları',
            onPressed: () => context.push('/admin/settings'),
          ),
          IconButton(
            icon: const Icon(Symbols.person_add),
            tooltip: 'Kullanıcı Ekle',
            onPressed: () => _showAddUserSheet(context, ref),
          ),
        ],
      ),
      body: async.when(
        data: (users) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_usersProvider);
            ref.invalidate(_locationsProvider);
          },
          child: ListView(
            children: [
              _AdminQuickLinks(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Text('Temsilci Konumları',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey)),
              ),
              _RepLocationsSection(),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Text('Kullanıcılar',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey)),
              ),
              _UserList(users: users, ref: ref),
            ],
          ),
        ),
        loading: () => const SkeletonList(),
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

// ── Temsilci Konumları ───────────────────────────────────────────────────────

class _RepLocationsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_locationsProvider);

    return async.when(
      data: (locs) {
        if (locs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Henüz konum verisi yok.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          );
        }
        return Column(
          children: locs.map((l) => _RepLocationTile(loc: l)).toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Hata: $e', style: const TextStyle(color: Colors.red, fontSize: 12)),
      ),
    );
  }
}

class _RepLocationTile extends StatelessWidget {
  const _RepLocationTile({required this.loc});
  final RepLocation loc;

  @override
  Widget build(BuildContext context) {
    final hasLocation = loc.lat != null && loc.lng != null;
    final lastSeen = loc.lastSeenAt;
    final String timeStr;
    if (lastSeen == null) {
      timeStr = 'Konum yok';
    } else {
      final diff = DateTime.now().difference(lastSeen.toLocal());
      if (diff.inMinutes < 1)        timeStr = 'Az önce';
      else if (diff.inHours < 1)     timeStr = '${diff.inMinutes} dk önce';
      else if (diff.inDays < 1)      timeStr = '${diff.inHours} saat önce';
      else                           timeStr = DateFormat('d MMM HH:mm', 'tr_TR').format(lastSeen.toLocal());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: (hasLocation ? AppColors.success : Colors.grey).withOpacity(0.1),
              child: Icon(
                hasLocation ? Symbols.location_on : Symbols.location_off,
                size: 18,
                color: hasLocation ? AppColors.success : Colors.grey,
                fill: 1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(timeStr, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
            if (hasLocation)
              TextButton.icon(
                onPressed: () => _openOnMaps(loc.lat!, loc.lng!, loc.fullName),
                icon: const Icon(Symbols.map, size: 14),
                label: const Text('Haritada Gör', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  foregroundColor: AppColors.info,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openOnMaps(double lat, double lng, String name) async {
    final label  = Uri.encodeComponent(name);
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng($label)');
    final httpUri = Uri.parse('https://maps.google.com/?q=$lat,$lng');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
    } else {
      await launchUrl(httpUri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Hızlı Bağlantılar ───────────────────────────────────────────────────────

class _AdminQuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Symbols.bar_chart,      label: 'Raporlar',  color: Colors.orange,     route: '/reports'),
      (icon: Symbols.view_kanban,    label: 'Kanban',    color: Colors.purple,     route: '/kanban'),
      (icon: Symbols.person,         label: 'Profil',    color: Colors.teal,       route: '/profile'),
      (icon: Symbols.search,         label: 'Ara',       color: Colors.indigo,     route: '/search'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => context.go(item.route),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: item.color.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Icon(item.icon, size: 20, color: item.color, fill: 1),
                      const SizedBox(height: 4),
                      Text(item.label,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item.color)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

  static final _roleLabels = {
    'Admin':   ('Yönetici',          AppColors.roleAdmin),
    'Manager': ('Müdür',             AppColors.warning.shade700),
    'Sales':   ('Satış Temsilcisi',  AppColors.roleSales),
  };

  Color get _avatarColor {
    final colors = AppColors.avatarPalette;
    return colors[user.fullName.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final (roleLabel, roleColor) = _roleLabels[user.role] ?? ('Bilinmiyor', Colors.grey);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
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
    HapticFeedback.mediumImpact();
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
        Icon(Symbols.check_circle, size: 56, color: AppColors.roleSales, fill: 1),
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
            color: AppColors.warning.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Personel ilk girişte şifresini değiştirmesi gerekecek.',
            style: TextStyle(fontSize: 12, color: AppColors.warning.shade800),
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
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
