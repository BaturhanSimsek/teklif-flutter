import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../data/reports_model.dart';
import '../data/reports_repository.dart';

final _reportsProvider = FutureProvider.autoDispose<ReportsData>(
    (ref) => ref.watch(reportsRepositoryProvider).get());

final _curr = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 0);

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_reportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raporlar'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.refresh),
            onPressed: () => ref.invalidate(_reportsProvider),
          ),
        ],
      ),
      body: async.when(
        data:    (d) => _ReportsBody(data: d),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}

class _ReportsBody extends StatelessWidget {
  const _ReportsBody({required this.data});
  final ReportsData data;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Genel Bakış ────────────────────────────────────────────────
          const _SectionTitle('Genel Bakış'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatCard(
              icon:  Symbols.description,
              label: 'Toplam Teklif',
              value: '${data.totalQuotes}',
              color: Theme.of(context).colorScheme.primary,
            )),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(
              icon:  Symbols.check_circle,
              label: 'Onaylanan',
              value: '${data.approvedQuotes}',
              color: AppColors.approved,
            )),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _StatCard(
              icon:  Symbols.hourglass_empty,
              label: 'Bekleyen',
              value: '${data.pendingQuotes}',
              color: AppColors.pending,
            )),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(
              icon:  Symbols.people,
              label: 'Müşteri',
              value: '${data.totalCustomers}',
              color: AppColors.roleAdmin,
            )),
          ]),
          const SizedBox(height: 20),

          // ── Ciro (TRY) ────────────────────────────────────────────────
          const _SectionTitle('Ciro (TRY)'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _RevenueCard(
              label:    'Bu Ay',
              value:    data.monthlyRevenueTry,
              sublabel: '+${data.newCustomersThisMonth} yeni müşteri',
              primary:  true,
            )),
            const SizedBox(width: 12),
            Expanded(child: _RevenueCard(
              label:    'Toplam (Onaylanan)',
              value:    data.totalRevenueTry,
              sublabel: 'Tüm zamanlar',
              primary:  false,
            )),
          ]),
          const SizedBox(height: 20),

          // ── Son 6 Ay Teklif Sayısı ────────────────────────────────────
          const _SectionTitle('Son 6 Ay — Teklif Sayısı'),
          const SizedBox(height: 10),
          _BarChart(stats: data.monthlySales),
          const SizedBox(height: 20),

          // ── Son 6 Ay Ciro ─────────────────────────────────────────────
          const _SectionTitle('Son 6 Ay — Onaylanan Ciro (TRY)'),
          const SizedBox(height: 10),
          _RevenueList(stats: data.monthlySales),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Bileşenler ────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String   label, value;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color, fill: 1),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w700, color: color)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.primary,
  });
  final String  label, sublabel;
  final double  value;
  final bool    primary;

  @override
  Widget build(BuildContext context) {
    final color = primary
        ? Theme.of(context).colorScheme.primary
        : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary ? color : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: primary ? Colors.transparent : Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: primary ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(
            _curr.format(value),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primary ? Colors.white : color,
            ),
          ),
          const SizedBox(height: 4),
          Text(sublabel,
              style: TextStyle(
                  fontSize: 11,
                  color: primary ? Colors.white54 : Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.stats});
  final List<MonthlyStat> stats;

  @override
  Widget build(BuildContext context) {
    final maxCount = stats.map((s) => s.count).fold(0, (a, b) => a > b ? a : b);
    final primary  = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: stats.map((s) {
            final ratio = maxCount == 0 ? 0.0 : s.count / maxCount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (s.count > 0)
                      Text('${s.count}',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primary)),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: 100 * ratio,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(s.month,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RevenueList extends StatelessWidget {
  const _RevenueList({required this.stats});
  final List<MonthlyStat> stats;

  @override
  Widget build(BuildContext context) {
    final maxRev  = stats.map((s) => s.revenue).fold(0.0, (a, b) => a > b ? a : b);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: stats.map((s) {
          final ratio = maxRev == 0 ? 0.0 : s.revenue / maxRev;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(s.month,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 88,
                  child: Text(
                    _curr.format(s.revenue),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: s.revenue > 0 ? primary : Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
