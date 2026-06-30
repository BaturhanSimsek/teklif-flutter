import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../data/tenant_model.dart';
import '../data/tenant_repository.dart';

final _settingsProvider = FutureProvider.autoDispose<TenantSettings>(
    (ref) => ref.watch(tenantRepositoryProvider).getSettings());

class CompanySettingsScreen extends ConsumerWidget {
  const CompanySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firma Ayarları'),
        centerTitle: false,
      ),
      body: async.when(
        data:    (s) => _SettingsForm(settings: s),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.settings});
  final TenantSettings settings;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late final _legalCtrl   = TextEditingController(text: widget.settings.companyLegalName);
  late final _cityCtrl    = TextEditingController(text: widget.settings.city);
  late final _phoneCtrl   = TextEditingController(text: widget.settings.phone);
  late final _emailCtrl   = TextEditingController(text: widget.settings.email);
  late final _taxNoCtrl   = TextEditingController(text: widget.settings.taxNumber);
  late final _taxOffCtrl  = TextEditingController(text: widget.settings.taxOffice);
  late final _addressCtrl = TextEditingController(text: widget.settings.address);
  late String? _primaryColor = widget.settings.primaryColor;
  bool _loading = false;

  static const _presetColors = [
    '#FF6452', // Inventix Coral
    '#1565C0', // Klasik Mavi
    '#263238', // Koyu Slate
    '#2E7D32', // Yeşil
    '#6A1B9A', // Mor
    '#E65100', // Turuncu
    '#00838F', // Teal
    '#C62828', // Kırmızı
  ];

  @override
  void dispose() {
    _legalCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _taxNoCtrl.dispose();
    _taxOffCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(tenantRepositoryProvider).updateSettings(
        companyLegalName: _legalCtrl.text.trim(),
        city:             _cityCtrl.text.trim(),
        phone:            _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        email:            _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        taxNumber:        _taxNoCtrl.text.trim().isEmpty ? null : _taxNoCtrl.text.trim(),
        taxOffice:        _taxOffCtrl.text.trim().isEmpty ? null : _taxOffCtrl.text.trim(),
        address:          _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        primaryColor:     _primaryColor,
      );
      ref.invalidate(_settingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Firma bilgileri kaydedildi.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Ticari ad (değiştirilemez — kayıt sırasında belirlendi)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Symbols.business, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ticari Ad', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(widget.settings.companyName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text('Ticari ad kayıt sırasında belirlenir.',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),

          const _Section(title: 'Şirket Bilgileri', icon: Symbols.apartment),
          _Field(_legalCtrl, 'Tüzel Ad (Fatura Adı)', Symbols.business_center,
              required: true),
          _Field(_cityCtrl, 'Şehir', Symbols.location_city),
          _Field(_addressCtrl, 'Adres', Symbols.home, maxLines: 2),
          const SizedBox(height: 16),

          const _Section(title: 'İletişim', icon: Symbols.contact_phone),
          _Field(_phoneCtrl, 'Telefon', Symbols.phone, keyboardType: TextInputType.phone),
          _Field(_emailCtrl, 'E-posta', Symbols.mail, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),

          const _Section(title: 'Vergi Bilgileri', icon: Symbols.receipt_long),
          _Field(_taxNoCtrl, 'Vergi Kimlik No', Symbols.tag,
              keyboardType: TextInputType.number),
          _Field(_taxOffCtrl, 'Vergi Dairesi', Symbols.account_balance),
          const SizedBox(height: 16),

          const _Section(title: 'PDF Marka Rengi', icon: Symbols.palette),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _presetColors.map((hex) {
              final selected = _primaryColor == hex;
              final color    = _parseHex(hex);
              return GestureDetector(
                onTap: () => setState(() => _primaryColor = hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: selected
                        ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 2)]
                        : null,
                  ),
                  child: selected
                      ? const Icon(Symbols.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Seçilen renk PDF tekliflerin başlığında ve tablo renklerinde kullanılır.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 32),

          FilledButton.icon(
            onPressed: _loading ? null : _save,
            icon: _loading
                ? const SizedBox(
                    height: 18, width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Symbols.save),
            label: const Text('Kaydet', style: TextStyle(fontSize: 16)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 20),

          // PDF önizleme notu
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.picture_as_pdf,
                    size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Bu bilgiler PDF teklif belgelerinin başlığında otomatik olarak kullanılır.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(
    this.controller,
    this.label,
    this.icon, {
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String   label;
  final IconData icon;
  final bool     required;
  final int      maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null
            : null,
      ),
    );
  }
}
