import '../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../form_templates/data/form_template_model.dart';
import '../../form_templates/data/form_template_repository.dart';

final _templatesProvider = FutureProvider.autoDispose<List<FormTemplate>>(
    (ref) => ref.watch(formTemplateRepositoryProvider).getAll());

class FormTemplatesScreen extends ConsumerWidget {
  const FormTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_templatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Şablonları'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context, ref),
        icon: const Icon(Symbols.add),
        label: const Text('Yeni Şablon'),
      ),
      body: async.when(
        data:    (list) => _TemplateList(templates: list, ref: ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }

  Future<void> _showCreateSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CreateTemplateSheet(onCreated: () {
        ref.invalidate(_templatesProvider);
      }),
    );
  }
}

// ── Liste ────────────────────────────────────────────────────────────────────

class _TemplateList extends StatelessWidget {
  const _TemplateList({required this.templates, required this.ref});
  final List<FormTemplate> templates;
  final WidgetRef ref;

  static const _fieldTypeLabels = {
    1: 'Metin', 2: 'Sayı', 3: 'Ondalık', 4: 'Seçenek',
    5: 'Çoklu Seçim', 6: 'Onay Kutusu', 7: 'Tarih', 8: 'Uzun Metin',
  };

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.article, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Henüz şablon yok', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: templates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _TemplateCard(
        template: templates[i],
        fieldTypeLabels: _fieldTypeLabels,
        ref: ref,
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.fieldTypeLabels,
    required this.ref,
  });
  final FormTemplate template;
  final Map<int, String> fieldTypeLabels;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(template.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      if (template.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Varsayılan',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!template.isDefault)
                  IconButton(
                    icon: const Icon(Symbols.delete_outline, size: 20,
                        color: AppColors.error),
                    onPressed: () => _delete(context),
                  ),
              ],
            ),
          ),
          if (template.description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(template.description!,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: template.fields.map((f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(
                  '${f.label} (${fieldTypeLabels[f.type] ?? '?'})',
                  style: const TextStyle(fontSize: 11),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Şablonu Sil'),
        content: Text('"${template.name}" şablonunu silmek istiyor musunuz?'),
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
      await ref.read(formTemplateRepositoryProvider).delete(template.id);
      ref.invalidate(_templatesProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }
}

// ── Şablon Oluşturma Sheet ───────────────────────────────────────────────────

class _CreateTemplateSheet extends StatefulWidget {
  const _CreateTemplateSheet({required this.onCreated});
  final VoidCallback onCreated;

  @override
  State<_CreateTemplateSheet> createState() => _CreateTemplateSheetState();
}

class _CreateTemplateSheetState extends State<_CreateTemplateSheet> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _fields   = <_FieldDraft>[];
  bool  _loading  = false;

  static const _typeOptions = [
    (1,  'Metin'),
    (2,  'Sayı'),
    (3,  'Ondalık'),
    (4,  'Seçenek (Açılır)'),
    (5,  'Çoklu Seçim'),
    (6,  'Onay Kutusu'),
    (7,  'Tarih'),
    (8,  'Uzun Metin'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _addField() => setState(() => _fields.add(_FieldDraft()));

  void _removeField(int i) => setState(() => _fields.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Yeni Şablon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Şablon Adı'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama (isteğe bağlı)'),
              ),
              const SizedBox(height: 16),

              // Alan listesi
              if (_fields.isNotEmpty) ...[
                const Text('Alanlar',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                ..._fields.asMap().entries.map((e) => _FieldRow(
                      draft:       e.value,
                      index:       e.key,
                      typeOptions: _typeOptions,
                      onRemove:    () => _removeField(e.key),
                    )),
                const SizedBox(height: 8),
              ],

              OutlinedButton.icon(
                onPressed: _addField,
                icon: const Icon(Symbols.add, size: 18),
                label: const Text('Alan Ekle'),
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: _loading ? null : () => _save(context, ref),
                child: _loading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Oluştur'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En az bir alan ekleyin.')));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(formTemplateRepositoryProvider).create(
        name:        _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        fields: _fields.asMap().entries.map((e) => {
          'key':          e.value.keyCtrl.text.trim().isEmpty
              ? 'field_${e.key + 1}'
              : e.value.keyCtrl.text.trim(),
          'label':        e.value.labelCtrl.text.trim(),
          'type':         e.value.type,
          'isRequired':   e.value.isRequired,
          'showInPdf':    true,
          'showInList':   false,
          'sortOrder':    e.key,
          'defaultValue': null,
          'options':      <String>[],
        }).toList(),
      );
      widget.onCreated();
      if (context.mounted) Navigator.pop(context);
    } catch (err) {
      setState(() => _loading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $err')));
      }
    }
  }
}

class _FieldDraft {
  final keyCtrl   = TextEditingController();
  final labelCtrl = TextEditingController();
  int  type       = 1;
  bool isRequired = false;
}

class _FieldRow extends StatefulWidget {
  const _FieldRow({
    required this.draft,
    required this.index,
    required this.typeOptions,
    required this.onRemove,
  });
  final _FieldDraft draft;
  final int index;
  final List<(int, String)> typeOptions;
  final VoidCallback onRemove;

  @override
  State<_FieldRow> createState() => _FieldRowState();
}

class _FieldRowState extends State<_FieldRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.draft.labelCtrl,
                  decoration: InputDecoration(
                    labelText: 'Alan Adı #${widget.index + 1}',
                    isDense: true,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Zorunlu' : null,
                ),
              ),
              IconButton(
                icon: const Icon(Symbols.close, size: 18, color: AppColors.error),
                onPressed: widget.onRemove,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: widget.draft.type,
                  isDense: true,
                  decoration: const InputDecoration(
                    labelText: 'Tür',
                    isDense: true,
                  ),
                  items: widget.typeOptions
                      .map((t) => DropdownMenuItem(value: t.$1, child: Text(t.$2)))
                      .toList(),
                  onChanged: (v) => setState(() => widget.draft.type = v!),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Checkbox(
                    value: widget.draft.isRequired,
                    onChanged: (v) => setState(() => widget.draft.isRequired = v!),
                  ),
                  const Text('Zorunlu', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
