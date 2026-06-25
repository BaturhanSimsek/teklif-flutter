import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/skeleton.dart';
import '../data/unit_model.dart';
import '../data/unit_repository.dart';

class UnitManagementScreen extends ConsumerWidget {
  const UnitManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(unitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birim Yönetimi'),
        centerTitle: false,
      ),
      body: async.when(
        data: (units) => units.isEmpty
            ? _emptyState(context, ref)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(unitsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: units.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, i) => _UnitCard(
                    unit: units[i],
                    onRefresh: () => ref.invalidate(unitsProvider),
                  ),
                ),
              ),
        loading: () => const SkeletonList(),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUnitSheet(context, ref, editing: null),
        icon: const Icon(Symbols.add),
        label: const Text('Birim Ekle'),
      ),
    );
  }

  Widget _emptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.straighten, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Henüz birim yok', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _showUnitSheet(context, ref, editing: null),
            icon: const Icon(Symbols.add),
            label: const Text('İlk Birimi Ekle'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUnitSheet(
    BuildContext context,
    WidgetRef ref, {
    required UnitModel? editing,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _UnitSheet(
        editing: editing,
        onSaved: () => ref.invalidate(unitsProvider),
      ),
    );
  }
}

// ── Birim Kartı ──────────────────────────────────────────────────────────────

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit, required this.onRefresh});
  final UnitModel unit;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Dismissible(
        key: Key(unit.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => _confirmDelete(context),
        onDismissed: (_) async {
          HapticFeedback.mediumImpact();
          try {
            await ref.read(unitRepositoryProvider).delete(unit.id);
            onRefresh();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$e')));
            }
          }
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Symbols.delete, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                unit.symbol.isNotEmpty ? unit.symbol : unit.name[0],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 13,
                ),
              ),
            ),
            title: Text(unit.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: unit.symbol.isNotEmpty
                ? Text('Kısaltma: ${unit.symbol}',
                    style: const TextStyle(fontSize: 12))
                : null,
            trailing: IconButton(
              icon: const Icon(Symbols.edit, size: 20),
              onPressed: () => _showSheet(context, ref),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Birim Sil'),
        content: Text('"${unit.name}" birimini silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _UnitSheet(
        editing: unit,
        onSaved: onRefresh,
      ),
    );
  }
}

// ── Bottom Sheet ─────────────────────────────────────────────────────────────

class _UnitSheet extends StatefulWidget {
  const _UnitSheet({this.editing, required this.onSaved});
  final UnitModel? editing;
  final VoidCallback onSaved;

  @override
  State<_UnitSheet> createState() => _UnitSheetState();
}

class _UnitSheetState extends State<_UnitSheet> {
  final _formKey     = GlobalKey<FormState>();
  late final _nameCtrl   = TextEditingController(text: widget.editing?.name);
  late final _symbolCtrl = TextEditingController(text: widget.editing?.symbol);
  bool _loading = false;

  bool get isEdit => widget.editing != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _symbolCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(unitRepositoryProvider);
    try {
      if (isEdit) {
        await repo.update(
          id:     widget.editing!.id,
          name:   _nameCtrl.text.trim(),
          symbol: _symbolCtrl.text.trim(),
        );
      } else {
        await repo.create(
          name:   _nameCtrl.text.trim(),
          symbol: _symbolCtrl.text.trim(),
        );
      }
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Birimi Düzenle' : 'Yeni Birim Ekle',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Birim Adı *',
                  prefixIcon: Icon(Symbols.straighten),
                  hintText: 'Örn: Adet, Kilogram, Litre',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _symbolCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kısaltma',
                  prefixIcon: Icon(Symbols.tag),
                  hintText: 'Örn: Adet, Kg, L',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : () => _save(ref),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(isEdit ? 'Güncelle' : 'Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
