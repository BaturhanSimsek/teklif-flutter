import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/customer_model.dart';
import '../data/customer_repository.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({super.key, this.existing});

  final Customer? existing;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _name      = TextEditingController();
  final _phone     = TextEditingController();
  final _email     = TextEditingController();
  final _address   = TextEditingController();
  final _taxNumber = TextEditingController();
  final _taxOffice = TextEditingController();
  final _notes     = TextEditingController();
  bool _loading    = false;

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    if (c != null) {
      _name.text      = c.name;
      _phone.text     = c.phone;
      _email.text     = c.email;
      _address.text   = c.address;
      _taxNumber.text = c.taxNumber ?? '';
      _taxOffice.text = c.taxOffice ?? '';
      _notes.text     = c.notes ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose(); _phone.dispose(); _email.dispose(); _address.dispose();
    _taxNumber.dispose(); _taxOffice.dispose(); _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      final c    = widget.existing;

      if (c == null) {
        await repo.create(
          name:      _name.text.trim(),
          phone:     _phone.text.trim(),
          email:     _email.text.trim(),
          address:   _address.text.trim(),
          taxNumber: _taxNumber.text.trim().isEmpty ? null : _taxNumber.text.trim(),
          taxOffice: _taxOffice.text.trim().isEmpty ? null : _taxOffice.text.trim(),
          notes:     _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        );
      } else {
        await repo.update(
          id:        c.id,
          name:      _name.text.trim(),
          phone:     _phone.text.trim(),
          email:     _email.text.trim(),
          address:   _address.text.trim(),
          taxNumber: _taxNumber.text.trim().isEmpty ? null : _taxNumber.text.trim(),
          taxOffice: _taxOffice.text.trim().isEmpty ? null : _taxOffice.text.trim(),
          notes:     _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        );
      }
      if (mounted) context.pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Müşteri Düzenle' : 'Yeni Müşteri'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Kaydet'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section('Temel Bilgiler'),
            _field(_name, 'Ad Soyad / Firma Adı *',
                icon: Icons.person_outline,
                validator: (v) => v == null || v.trim().isEmpty ? 'Ad gerekli' : null),
            _field(_phone, 'Telefon',
                icon: Icons.phone_outlined,
                type: TextInputType.phone),
            _field(_email, 'E-posta',
                icon: Icons.email_outlined,
                type: TextInputType.emailAddress),
            _field(_address, 'Adres',
                icon: Icons.location_on_outlined,
                maxLines: 3),
            const SizedBox(height: 20),
            _section('Vergi Bilgileri (opsiyonel)'),
            _field(_taxNumber, 'Vergi No', icon: Icons.numbers),
            _field(_taxOffice, 'Vergi Dairesi', icon: Icons.account_balance_outlined),
            const SizedBox(height: 20),
            _section('Notlar'),
            _field(_notes, 'Notlar', icon: Icons.notes, maxLines: 3),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: Text(isEdit ? 'Güncelle' : 'Müşteri Oluştur',
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      );

  Widget _field(
    TextEditingController ctrl,
    String label, {
    IconData? icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          keyboardType: type,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
        ),
      );
}
