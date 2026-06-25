import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/skeleton.dart';
import '../data/category_model.dart';
import '../data/category_repository.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Yönetimi'),
        centerTitle: false,
      ),
      body: async.when(
        data: (cats) => cats.isEmpty
            ? _emptyState(context, ref)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(categoriesProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: cats.length,
                  itemBuilder: (_, i) => _CategoryTile(
                    category: cats[i],
                    depth: 0,
                    onRefresh: () => ref.invalidate(categoriesProvider),
                  ),
                ),
              ),
        loading: () => const SkeletonList(),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategorySheet(context, ref, parent: null),
        icon: const Icon(Symbols.add),
        label: const Text('Ana Kategori'),
      ),
    );
  }

  Widget _emptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.category, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Henüz kategori yok', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _showCategorySheet(context, ref, parent: null),
            icon: const Icon(Symbols.add),
            label: const Text('İlk Kategoriyi Ekle'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategorySheet(
    BuildContext context,
    WidgetRef ref, {
    required CategoryModel? parent,
    CategoryModel? editing,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CategorySheet(
        parent: parent,
        editing: editing,
        onSaved: () => ref.invalidate(categoriesProvider),
      ),
    );
  }
}

// ── Tile (recursive) ─────────────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.depth,
    required this.onRefresh,
  });

  final CategoryModel category;
  final int depth;
  final VoidCallback onRefresh;

  static const _indentPerLevel = 16.0;

  @override
  Widget build(BuildContext context) {
    final hasChildren = category.children.isNotEmpty;
    final color = Theme.of(context).colorScheme.primary;

    final tile = Material(
      color: Colors.transparent,
      child: Consumer(
        builder: (context, ref, _) => ListTile(
          contentPadding: EdgeInsets.only(
            left: 16 + depth * _indentPerLevel,
            right: 8,
          ),
          leading: Icon(
            hasChildren ? Symbols.folder : Symbols.label,
            size: 20,
            color: hasChildren ? color : Colors.grey.shade500,
          ),
          title: Text(
            category.name,
            style: TextStyle(
              fontWeight: depth == 0 ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Symbols.more_vert, size: 20),
            onSelected: (v) => _onAction(context, ref, v),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'add_child',
                child: Row(children: [
                  Icon(Symbols.add, size: 18),
                  SizedBox(width: 10),
                  Text('Alt Kategori Ekle'),
                ]),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Symbols.edit, size: 18),
                  SizedBox(width: 10),
                  Text('Düzenle'),
                ]),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Symbols.delete, size: 18, color: AppColors.error),
                  const SizedBox(width: 10),
                  Text('Sil', style: TextStyle(color: AppColors.error)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );

    if (!hasChildren) return tile;

    return ExpansionTile(
      tilePadding: EdgeInsets.only(
        left: 16 + depth * _indentPerLevel,
        right: 8,
      ),
      leading: Icon(Symbols.folder_open, size: 20, color: color),
      title: Consumer(
        builder: (context, ref, _) => Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontWeight: depth == 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Symbols.more_vert, size: 20),
              onSelected: (v) => _onAction(context, ref, v),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'add_child',
                  child: Row(children: [
                    Icon(Symbols.add, size: 18),
                    SizedBox(width: 10),
                    Text('Alt Kategori Ekle'),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Symbols.edit, size: 18),
                    SizedBox(width: 10),
                    Text('Düzenle'),
                  ]),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Symbols.delete, size: 18, color: AppColors.error),
                    const SizedBox(width: 10),
                    Text('Sil', style: TextStyle(color: AppColors.error)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
      children: category.children
          .map((child) => _CategoryTile(
                category: child,
                depth: depth + 1,
                onRefresh: onRefresh,
              ))
          .toList(),
    );
  }

  Future<void> _onAction(BuildContext context, WidgetRef ref, String action) async {
    HapticFeedback.selectionClick();
    switch (action) {
      case 'add_child':
        await _showSheet(context, ref, parent: category, editing: null);
      case 'edit':
        await _showSheet(context, ref, parent: null, editing: category);
      case 'delete':
        await _delete(context, ref);
    }
  }

  Future<void> _showSheet(
    BuildContext context,
    WidgetRef ref, {
    CategoryModel? parent,
    CategoryModel? editing,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CategorySheet(
        parent: parent,
        editing: editing,
        onSaved: onRefresh,
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kategori Sil'),
        content: Text(
          '"${category.name}" kategorisini silmek istiyor musunuz?\n\n'
          'Alt kategorileri olan bir kategori silinemez.',
        ),
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
    if (confirm != true) return;
    try {
      await ref.read(categoryRepositoryProvider).delete(category.id);
      onRefresh();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

// ── Bottom Sheet ─────────────────────────────────────────────────────────────

class _CategorySheet extends StatefulWidget {
  const _CategorySheet({
    this.parent,
    this.editing,
    required this.onSaved,
  });
  final CategoryModel? parent;
  final CategoryModel? editing;
  final VoidCallback onSaved;

  @override
  State<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<_CategorySheet> {
  final _formKey  = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.editing?.name);
  bool _loading = false;

  bool get isEdit => widget.editing != null;
  String get _title => isEdit
      ? 'Kategoriyi Düzenle'
      : widget.parent != null
          ? '"${widget.parent!.name}" Altına Ekle'
          : 'Ana Kategori Ekle';

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(categoryRepositoryProvider);
    try {
      if (isEdit) {
        await repo.update(
          id:       widget.editing!.id,
          name:     _nameCtrl.text.trim(),
          parentId: widget.editing!.parentId,
        );
      } else {
        await repo.create(
          name:     _nameCtrl.text.trim(),
          parentId: widget.parent?.id,
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
              Text(_title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Kategori Adı *',
                  prefixIcon: Icon(Symbols.label),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
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
