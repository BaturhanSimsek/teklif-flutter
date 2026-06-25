import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/presentation/customer_providers.dart';
import '../data/visit_plan_model.dart';
import '../data/visit_plan_repository.dart';

class VisitPlanScreen extends ConsumerStatefulWidget {
  const VisitPlanScreen({super.key});

  @override
  ConsumerState<VisitPlanScreen> createState() => _VisitPlanScreenState();
}

class _VisitPlanScreenState extends ConsumerState<VisitPlanScreen> {
  DateTime _selectedDate = DateTime.now();

  String get _dateParam {
    final d = _selectedDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  late final _plansProvider = FutureProvider.family<List<VisitPlan>, String>((ref, date) =>
      ref.watch(visitPlanRepositoryProvider).getPlans(date: date));

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final async = ref.watch(_plansProvider(_dateParam));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ziyaret Planı'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.calendar_today),
            tooltip: 'Tarih Seç',
            onPressed: () => _pickDate(context),
          ),
          IconButton(
            icon: const Icon(Symbols.add),
            tooltip: 'Ziyaret Planla',
            onPressed: () => _showCreateSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateStrip(
            date: _selectedDate,
            onPrev: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
            onNext: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
            primary: primary,
          ),
          Expanded(
            child: async.when(
              data: (plans) => plans.isEmpty
                  ? _emptyState()
                  : RefreshIndicator(
                      onRefresh: () => ref.refresh(_plansProvider(_dateParam).future),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: plans.length,
                        itemBuilder: (_, i) => _VisitCard(
                          plan: plans[i],
                          onStatusChanged: () => ref.invalidate(_plansProvider(_dateParam)),
                        ),
                      ),
                    ),
              loading: () => const SkeletonList(),
              error: (e, _) => Center(child: Text('Hata: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _showCreateSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CreateVisitSheet(
        initialDate: _selectedDate,
        onCreated: () => ref.invalidate(_plansProvider(_dateParam)),
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.calendar_month, size: 64, color: Colors.grey.shade400, fill: 1),
            const SizedBox(height: 12),
            Text(
              DateFormat('d MMMM yyyy', 'tr_TR').format(_selectedDate) ==
                DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now())
                  ? 'Bugün ziyaret planı yok'
                  : 'Bu gün için ziyaret yok',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _showCreateSheet(context),
              icon: const Icon(Symbols.add),
              label: const Text('Ziyaret Ekle'),
            ),
          ],
        ),
      );
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.date,
    required this.onPrev,
    required this.onNext,
    required this.primary,
  });
  final DateTime date;
  final VoidCallback onPrev, onNext;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Symbols.chevron_left, size: 20),
            onPressed: onPrev,
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE', 'tr_TR').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isToday ? primary : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('d MMMM yyyy', 'tr_TR').format(date),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isToday ? primary : null,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Symbols.chevron_right, size: 20),
            onPressed: onNext,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _VisitCard extends ConsumerWidget {
  const _VisitCard({required this.plan, required this.onStatusChanged});
  final VisitPlan plan;
  final VoidCallback onStatusChanged;

  static const _statusColors = {
    0: AppColors.info,
    1: AppColors.success,
    2: AppColors.error,
  };
  static const _statusLabels = {
    0: 'Planlandı',
    1: 'Tamamlandı',
    2: 'İptal',
  };
  static const _statusIcons = {
    0: Symbols.schedule,
    1: Symbols.check_circle,
    2: Symbols.cancel,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _statusColors[plan.status] ?? AppColors.info;
    final label = _statusLabels[plan.status] ?? '';
    final icon  = _statusIcons[plan.status] ?? Symbols.schedule;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(Symbols.business, color: color, size: 20, fill: 1),
            ),
            title: Text(
              plan.customerName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Text(
              DateFormat('HH:mm').format(plan.plannedAt.toLocal()),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 13, color: color, fill: 1),
                  const SizedBox(width: 4),
                  Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          if (plan.customerAddress.isNotEmpty || plan.customerPhone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  if (plan.customerPhone.isNotEmpty)
                    _InfoRow(icon: Symbols.call, text: plan.customerPhone),
                  if (plan.customerAddress.isNotEmpty)
                    _InfoRow(icon: Symbols.location_on, text: plan.customerAddress),
                ],
              ),
            ),

          if (plan.notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Icon(Symbols.note, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      plan.notes!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),

          if (plan.outcome != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Icon(Symbols.feedback, size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      plan.outcome!,
                      style: const TextStyle(fontSize: 12, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 4),
          Divider(height: 1, color: Theme.of(context).dividerColor),

          Row(
            children: [
              if (plan.customerAddress.isNotEmpty)
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _openMaps(plan.customerAddress),
                    icon: const Icon(Symbols.map, size: 16),
                    label: const Text('Haritada Aç', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor: Colors.grey.shade600,
                    ),
                  ),
                ),
              if (plan.status == 0) ...[
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _complete(context, ref),
                    icon: const Icon(Symbols.check_circle, size: 16),
                    label: const Text('Tamamla', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor: AppColors.success,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _cancel(ref),
                    icon: const Icon(Symbols.cancel, size: 16),
                    label: const Text('İptal', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openMaps(String address) async {
    final encoded = Uri.encodeComponent(address);
    // geo: scheme — Android Maps uygulaması doğrudan açar
    final geoUri  = Uri.parse('geo:0,0?q=$encoded');
    // Fallback: tarayıcıda Google Maps
    final httpUri = Uri.parse('https://maps.google.com/?q=$encoded');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
    } else if (await canLaunchUrl(httpUri)) {
      await launchUrl(httpUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final outcome = await showDialog<String>(
      context: context,
      builder: (_) => _OutcomeDialog(),
    );
    if (outcome == null) return;
    await ref.read(visitPlanRepositoryProvider).updateStatus(plan.id, 1, outcome: outcome.isEmpty ? null : outcome);
    onStatusChanged();
  }

  Future<void> _cancel(WidgetRef ref) async {
    await ref.read(visitPlanRepositoryProvider).updateStatus(plan.id, 2);
    onStatusChanged();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, size: 13, color: Colors.grey.shade400),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}

class _OutcomeDialog extends StatelessWidget {
  _OutcomeDialog();
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Ziyaret Sonucu'),
        content: TextField(
          controller: _ctrl,
          decoration: const InputDecoration(hintText: 'Ziyaret notunu yazın (isteğe bağlı)'),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(context, _ctrl.text),
            child: const Text('Tamamla'),
          ),
        ],
      );
}

class _CreateVisitSheet extends ConsumerStatefulWidget {
  const _CreateVisitSheet({required this.initialDate, required this.onCreated});
  final DateTime initialDate;
  final VoidCallback onCreated;

  @override
  ConsumerState<_CreateVisitSheet> createState() => _CreateVisitSheetState();
}

class _CreateVisitSheetState extends ConsumerState<_CreateVisitSheet> {
  String? _customerId;
  String  _customerName = '';
  late DateTime _plannedAt;
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _plannedAt = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
      9, 0,
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider());

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ziyaret Planla',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          // Müşteri seç
          customersAsync.when(
            data: (paged) => DropdownButtonFormField<String>(
              initialValue: _customerId,
              decoration: const InputDecoration(
                labelText: 'Müşteri *',
                prefixIcon: Icon(Symbols.business),
              ),
              items: paged.items
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _customerId   = v;
                  _customerName = paged.items.firstWhere((c) => c.id == v).name;
                });
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Hata: $e'),
          ),
          const SizedBox(height: 16),

          // Tarih & Saat
          InkWell(
            onTap: () => _pickDateTime(context),
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tarih ve Saat *',
                prefixIcon: Icon(Symbols.calendar_clock),
              ),
              child: Text(
                DateFormat('d MMMM yyyy HH:mm', 'tr_TR').format(_plannedAt),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Not (isteğe bağlı)',
              prefixIcon: Icon(Symbols.note),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: (_loading || _customerId == null) ? null : _save,
            child: _loading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Planla'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _plannedAt,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!mounted || date == null) return;
    // ignore: use_build_context_synchronously
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_plannedAt),
    );
    if (time == null) return;
    setState(() => _plannedAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (_customerId == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(visitPlanRepositoryProvider).create(
        customerId: _customerId!,
        plannedAt: _plannedAt.toUtc(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      widget.onCreated();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }
}
