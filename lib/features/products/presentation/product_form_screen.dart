import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../data/product_model.dart';
import '../data/product_repository.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.product});
  final Product? product;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey        = GlobalKey<FormState>();
  late final _nameCtrl  = TextEditingController(text: widget.product?.name);
  late final _unitCtrl  = TextEditingController(text: widget.product?.unit ?? 'Adet');
  late final _saleCtrl  = TextEditingController(
      text: widget.product?.salePrice.toStringAsFixed(2) ?? '');
  late final _costCtrl  = TextEditingController(
      text: widget.product?.purchasePrice.toStringAsFixed(2) ?? '');
  late final _notesCtrl = TextEditingController(text: widget.product?.notes);
  bool _loading = false;

  bool get isEdit => widget.product != null;

  static const _units = ['Adet', 'Kg', 'Litre', 'Metre', 'M²', 'M³', 'Paket', 'Kutu', 'Takım', 'Set'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
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
          unit:          _unitCtrl.text.trim(),
          salePrice:     sale,
          purchasePrice: cost,
          notes:         _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
      } else {
        await repo.create(
          name:          _nameCtrl.text.trim(),
          unit:          _unitCtrl.text.trim(),
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
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
                  width: 20, height: 20,
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

            // Birim — dropdown + serbest giriş
            DropdownButtonFormField<String>(
              value: _units.contains(_unitCtrl.text) ? _unitCtrl.text : null,
              decoration: const InputDecoration(
                labelText: 'Birim *',
                prefixIcon: Icon(Symbols.straighten),
              ),
              items: _units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (v) {
                if (v != null) _unitCtrl.text = v;
              },
              validator: (_) => _unitCtrl.text.trim().isEmpty ? 'Zorunlu alan' : null,
            ),
            const SizedBox(height: 24),

            _section('Fiyatlar', Symbols.payments, primary),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _saleCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Satış Fiyatı *',
                    prefixIcon: Icon(Symbols.sell),
                    suffixText: '₺',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Zorunlu';
                    if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Geçersiz';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFormField(
                  controller: _costCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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
