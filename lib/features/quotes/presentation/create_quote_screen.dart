import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../customers/presentation/customer_providers.dart';
import '../../exchange_rate/data/exchange_rate_repository.dart';
import '../../form_templates/data/form_template_model.dart';
import '../../form_templates/data/form_template_repository.dart';
import '../data/ai_quote_suggestion.dart';
import '../data/quote_repository.dart';

class CreateQuoteScreen extends ConsumerStatefulWidget {
  const CreateQuoteScreen({
    super.key,
    this.preCustomerId,
    this.preCustomerName,
  });

  final String? preCustomerId;
  final String? preCustomerName;

  @override
  ConsumerState<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends ConsumerState<CreateQuoteScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _customerId;
  FormTemplate? _template;
  final _paymentTerm  = TextEditingController(text: 'Peşin');
  final _deliveryDays = TextEditingController(text: '7');
  final _kdvRate      = TextEditingController(text: '20');
  final _discountRate = TextEditingController(text: '0');
  final _notes        = TextEditingController();
  String _currency    = 'TRY';

  final Map<String, dynamic> _customFields = {};
  final List<_ItemRow> _items = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _customerId = widget.preCustomerId;
    _addItem();
  }

  @override
  void dispose() {
    _paymentTerm.dispose();
    _deliveryDays.dispose();
    _kdvRate.dispose();
    _discountRate.dispose();
    _notes.dispose();
    for (final r in _items) r.dispose();
    super.dispose();
  }

  void _addItem() => setState(() => _items.add(_ItemRow()));

  void _applyAiSuggestions(List<AiQuoteItemSuggestion> suggestions) {
    // Varsa boş tek kalem temizle
    if (_items.length == 1 &&
        _items[0].desc.text.isEmpty &&
        _items[0].price.text.isEmpty) {
      _items[0].dispose();
      _items.clear();
    }
    for (final s in suggestions) {
      final row = _ItemRow();
      row.desc.text  = s.productName;
      row.qty.text   = s.quantity.toString();
      row.price.text = s.unitPrice.toStringAsFixed(2);
      row.unit.text  = s.unit;
      _items.add(row);
    }
    setState(() {});
  }

  Future<void> _showAiDialog() async {
    final promptCtrl = TextEditingController();
    final suggestions = await showModalBottomSheet<List<AiQuoteItemSuggestion>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AiPromptSheet(promptCtrl: promptCtrl, ref: ref),
    );
    if (suggestions != null && suggestions.isNotEmpty) {
      _applyAiSuggestions(suggestions);
    }
  }

  void _removeItem(int i) {
    if (_items.length == 1) return;
    _items[i].dispose();
    setState(() => _items.removeAt(i));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_customerId == null) { _showError('Müşteri seçin.'); return; }
    if (_template == null)   { _showError('Form şablonu seçin.'); return; }

    setState(() => _loading = true);
    try {
      final id = await ref.read(quoteRepositoryProvider).create({
        'customerId':     _customerId,
        'formTemplateId': _template!.id,
        'paymentTerm':    _paymentTerm.text.trim(),
        'deliveryDays':   _deliveryDays.text.trim(),
        'kdvRate':        double.tryParse(_kdvRate.text) ?? 20,
        'discountRate':   double.tryParse(_discountRate.text) ?? 0,
        'notes':          _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        'language':       'tr',
        'currency':       _currency,
        'items': _items.map((r) => {
          'description':  r.desc.text.trim(),
          'quantity':     double.tryParse(r.qty.text)   ?? 1,
          'unitPrice':    double.tryParse(r.price.text) ?? 0,
          'unit':         r.unit.text.trim().isEmpty ? 'Adet' : r.unit.text.trim(),
          'customFields': Map<String, dynamic>.from(_customFields),
        }).toList(),
      });
      if (mounted) context.pushReplacement('/quotes/$id');
    } catch (e) {
      _showError('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Theme.of(context).colorScheme.error),
      );

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(formTemplatesProvider);
    final customersAsync = ref.watch(customersProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Teklif'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Oluştur'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // Müşteri seçimi
            _sectionTitle('Müşteri'),
            customersAsync.when(
              data: (list) => DropdownButtonFormField<String>(
                value: _customerId,
                decoration: const InputDecoration(
                  labelText: 'Müşteri *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: list.items.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _customerId = v),
                validator: (v) => v == null ? 'Müşteri seçin' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
            const SizedBox(height: 16),

            // Form şablonu
            _sectionTitle('Form Şablonu'),
            templatesAsync.when(
              data: (list) => DropdownButtonFormField<FormTemplate>(
                value: _template,
                decoration: const InputDecoration(
                  labelText: 'Şablon *',
                  prefixIcon: Icon(Icons.article_outlined),
                ),
                items: list.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (t) => setState(() {
                  _template = t;
                  _customFields.clear();
                  if (t != null) {
                    for (final f in t.fields) {
                      _customFields[f.key] = f.defaultValue ?? '';
                    }
                  }
                }),
                validator: (v) => v == null ? 'Şablon seçin' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),

            // Dinamik alanlar
            if (_template != null && _template!.fields.isNotEmpty) ...[
              const SizedBox(height: 20),
              _sectionTitle('Ürün / Hizmet Detayları'),
              ..._template!.fields.map((f) => _DynamicField(
                field: f,
                value: _customFields[f.key],
                onChanged: (v) => setState(() => _customFields[f.key] = v),
              )),
            ],

            // Kalemler
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: _sectionTitle('Kalemler')),
              TextButton.icon(
                onPressed: _showAiDialog,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('AI ile Oluştur'),
              ),
              TextButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Kalem Ekle'),
              ),
            ]),
            ..._items.asMap().entries.map((e) => _ItemRowWidget(
              row: e.value,
              index: e.key,
              onRemove: () => _removeItem(e.key),
              showRemove: _items.length > 1,
            )),

            // Teklif koşulları
            const SizedBox(height: 20),
            _sectionTitle('Teklif Koşulları'),
            Row(children: [
              Expanded(child: _plainField(_paymentTerm, 'Ödeme Koşulu')),
              const SizedBox(width: 12),
              Expanded(child: _plainField(_deliveryDays, 'Teslimat (gün)', type: TextInputType.number)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _plainField(_kdvRate, 'KDV %', type: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _plainField(_discountRate, 'İndirim %', type: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: const InputDecoration(labelText: 'Döviz', isDense: true),
                      items: const [
                        DropdownMenuItem(value: 'TRY', child: Text('₺ TRY')),
                        DropdownMenuItem(value: 'USD', child: Text('\$ USD')),
                        DropdownMenuItem(value: 'EUR', child: Text('€ EUR')),
                        DropdownMenuItem(value: 'GBP', child: Text('£ GBP')),
                      ],
                      onChanged: (v) => setState(() => _currency = v ?? 'TRY'),
                    ),
                    if (_currency != 'TRY') ...[
                      const SizedBox(height: 4),
                      _ExchangeRateChip(currency: _currency),
                    ],
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notlar',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 32),

            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('Teklif Oluştur', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      );

  Widget _plainField(TextEditingController ctrl, String label,
          {TextInputType type = TextInputType.text}) =>
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(labelText: label, isDense: true),
      );
}

class _ExchangeRateChip extends ConsumerWidget {
  const _ExchangeRateChip({required this.currency});
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratesAsync = ref.watch(exchangeRatesProvider);
    return ratesAsync.when(
      loading: () => const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 1.5)),
      error: (_, __) => const SizedBox.shrink(),
      data: (rates) {
        final rate = rates[currency];
        if (rate == null) return const SizedBox.shrink();
        return Text(
          '1 $currency = ${rate.toStringAsFixed(4)} ₺',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }
}

// Dinamik alan widget

class _DynamicField extends StatelessWidget {
  const _DynamicField({required this.field, required this.value, required this.onChanged});

  final TemplateField field;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: switch (field.type) {
        4 => DropdownButtonFormField<String>(
          value: (value?.toString().isEmpty ?? true) ? null : value?.toString(),
          decoration: InputDecoration(labelText: field.label),
          items: field.options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: (v) => onChanged(v),
          validator: field.isRequired ? (v) => v == null ? '${field.label} gerekli' : null : null,
        ),
        6 => CheckboxListTile(
          title: Text(field.label),
          value: value == true || value == 'true',
          onChanged: (v) => onChanged(v),
          contentPadding: EdgeInsets.zero,
        ),
        8 => TextFormField(
          initialValue: value?.toString() ?? '',
          maxLines: 3,
          decoration: InputDecoration(labelText: field.label),
          onChanged: onChanged,
          validator: field.isRequired
              ? (v) => (v == null || v.isEmpty) ? '${field.label} gerekli' : null
              : null,
        ),
        _ => TextFormField(
          initialValue: value?.toString() ?? '',
          keyboardType: (field.type == 2 || field.type == 3)
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(labelText: field.label),
          onChanged: onChanged,
          validator: field.isRequired
              ? (v) => (v == null || v.isEmpty) ? '${field.label} gerekli' : null
              : null,
        ),
      },
    );
  }
}

// Kalem satırı

class _ItemRow {
  final desc  = TextEditingController();
  final qty   = TextEditingController(text: '1');
  final price = TextEditingController();
  final unit  = TextEditingController(text: 'Adet');

  void dispose() {
    desc.dispose(); qty.dispose(); price.dispose(); unit.dispose();
  }
}

class _ItemRowWidget extends StatelessWidget {
  const _ItemRowWidget({
    required this.row,
    required this.index,
    required this.onRemove,
    required this.showRemove,
  });

  final _ItemRow row;
  final int index;
  final VoidCallback onRemove;
  final bool showRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: colors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(children: [
              Text('Kalem ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (showRemove)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
            ]),
            const SizedBox(height: 8),
            TextFormField(
              controller: row.desc,
              decoration: const InputDecoration(labelText: 'Açıklama *', isDense: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Açıklama gerekli' : null,
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: row.price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Birim Fiyat *', isDense: true),
                  validator: (v) => (v == null || v.isEmpty) ? 'Fiyat girin' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: row.qty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Miktar', isDense: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: row.unit,
                  decoration: const InputDecoration(labelText: 'Birim', isDense: true),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// AI Prompt Bottom Sheet

class _AiPromptSheet extends StatefulWidget {
  const _AiPromptSheet({required this.promptCtrl, required this.ref});

  final TextEditingController promptCtrl;
  final WidgetRef ref;

  @override
  State<_AiPromptSheet> createState() => _AiPromptSheetState();
}

class _AiPromptSheetState extends State<_AiPromptSheet> {
  bool _loading = false;
  String? _error;

  Future<void> _generate() async {
    final prompt = widget.promptCtrl.text.trim();
    if (prompt.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      final suggestions = await widget.ref
          .read(quoteRepositoryProvider)
          .aiGenerate(prompt);
      if (mounted) Navigator.of(context).pop(suggestions);
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors  = Theme.of(context).colorScheme;
    final padding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(Icons.auto_awesome, color: colors.primary),
            const SizedBox(width: 10),
            Text('AI ile Kalem Oluştur',
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              visualDensity: VisualDensity.compact,
            ),
          ]),
          const SizedBox(height: 4),
          Text(
            'Ne yapılacağını yazın, AI ürün kataloğundan uygun kalemleri seçsin.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.promptCtrl,
            maxLines: 3,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Örn: 50m² mutfak tezgah üstü seramik kaplama',
              border: const OutlineInputBorder(),
              filled: true,
            ),
            onSubmitted: (_) => _generate(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: TextStyle(color: colors.error, fontSize: 12)),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.auto_awesome),
            label: Text(_loading ? 'Oluşturuluyor...' : 'Oluştur'),
          ),
        ],
      ),
    );
  }
}
