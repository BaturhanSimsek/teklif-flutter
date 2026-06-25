import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../categories/data/category_model.dart';
import '../../categories/data/category_repository.dart';
import '../../units/data/unit_model.dart';
import '../../units/data/unit_repository.dart';
import '../data/product_model.dart';
import '../data/product_repository.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey       = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.product?.name);
  late final _saleCtrl = TextEditingController(
      text: widget.product?.salePrice.toStringAsFixed(2) ?? '');
  late final _costCtrl = TextEditingController(
      text: widget.product?.purchasePrice.toStringAsFixed(2) ?? '');
  late final _notesCtrl = TextEditingController(text: widget.product?.notes);

  String? _selectedUnitId;
  String? _selectedCategoryId;
  bool _loading = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    _selectedUnitId     = widget.product?.unitId;
    _selectedCategoryId = widget.product?.categoryId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _saleCtrl.dispose();
    _costCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final repo = ref.read(productRepositoryProvider);
    final sale = double.tryParse(_saleCtrl.text.replaceAll(',', '.')) ?? 0;
    final cost = double.tryParse(_costCtrl.text.replaceAll(',', '.')) ?? 0;

    try {
      if (isEdit) {
        await repo.update(
          id:            widget.product!.id,
          name:          _nameCtrl.text.trim(),
          unitId:        _selectedUnitId,
          categoryId:    _selectedCategoryId,
          salePrice:     sale,
          purchasePrice: cost,
          notes:         _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      } else {
        await repo.create(
          name:          _nameCtrl.text.trim(),
          unitId:        _selectedUnitId,
          categoryId:    _selectedCategoryId,
          salePrice:     sale,
          purchasePrice: cost,
          notes:         _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary     = Theme.of(context).colorScheme.primary;
    final unitsAsync  = ref.watch(unitsProvider);
    final catsAsync   = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ürünü Düzenle' : 'Yeni Ürün'),
        centerTitle: false,
        actions: [
          if (!_loading)
            TextButton(
              onPressed: _save,
              child: const Text('Kaydet',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )
          else
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _section('Ürün Bilgileri', Symbols.inventory_2, primary),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Ürün Adı *',
                prefixIcon: Icon(Symbols.label),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
            ),
            const SizedBox(height: 14),

            // Birim dropdown (API)
            unitsAsync.when(
              data: (units) => _UnitDropdown(
                units:    units,
                value:    _selectedUnitId,
                onChanged: (v) => setState(() => _selectedUnitId = v),
              ),
              loading: () => const LinearProgressIndicator(),
              error:   (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),

            // Kategori dropdown (API — flatten tree)
            catsAsync.when(
              data: (cats) => _CategoryDropdown(
                categories: _flattenTree(cats),
                value:      _selectedCategoryId,
                onChanged:  (v) => setState(() => _selectedCategoryId = v),
              ),
              loading: () => const LinearProgressIndicator(),
              error:   (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            _section('Fiyatlar', Symbols.payments, primary),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _saleCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Satış Fiyatı *',
                    prefixIcon: Icon(Symbols.sell),
                    suffixText: '₺',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Zorunlu';
                    if (double.tryParse(v.replaceAll(',', '.')) == null)
                      return 'Geçersiz';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFormField(
                  controller: _costCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Maliyet',
                    prefixIcon: Icon(Symbols.shopping_bag),
                    suffixText: '₺',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),

            _section('Ek Bilgiler', Symbols.notes, primary),
            const SizedBox(height: 12),

            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notlar',
                prefixIcon: Icon(Symbols.edit_note),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Symbols.save),
              label: Text(isEdit ? 'Güncelle' : 'Ürün Ekle',
                  style: const TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }

  List<({String id, String label, int depth})> _flattenTree(
      List<CategoryModel> cats) {
    final result = <({String id, String label, int depth})>[];
    void walk(List<CategoryModel> nodes, int depth) {
      for (final c in nodes) {
        result.add((id: c.id, label: c.name, depth: depth));
        if (c.children.isNotEmpty) walk(c.children, depth + 1);
      }
    }
    walk(cats, 0);
    return result;
  }

  Widget _section(String title, IconData icon, Color color) => Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        ],
      );
}

// ── Birim Dropdown ────────────────────────────────────────────────────────────

class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    required this.units,
    required this.value,
    required this.onChanged,
  });
  final List<UnitModel> units;
  final String? value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) return const SizedBox.shrink();
    final validValue = units.any((u) => u.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: const InputDecoration(
        labelText: 'Birim',
        prefixIcon: Icon(Symbols.straighten),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('— Seçiniz —')),
        ...units.map((u) => DropdownMenuItem(
              value: u.id,
              child: Text(u.symbol.isNotEmpty ? '${u.name} (${u.symbol})' : u.name),
            )),
      ],
      onChanged: onChanged,
    );
  }
}

// ── Kategori Dropdown ─────────────────────────────────────────────────────────

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });
  final List<({String id, String label, int depth})> categories;
  final String? value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final validValue =
        categories.any((c) => c.id == value) ? value : null;
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        prefixIcon: Icon(Symbols.category),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('— Seçiniz —')),
        ...categories.map((c) => DropdownMenuItem(
              value: c.id,
              child: Padding(
                padding: EdgeInsets.only(left: c.depth * 16.0),
                child: Text(c.label),
              ),
            )),
      ],
      onChanged: onChanged,
    );
  }
}
