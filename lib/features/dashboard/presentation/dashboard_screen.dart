import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../data/dashboard_model.dart';
import '../data/dashboard_repository.dart';

final _dashboardProvider = FutureProvider.autoDispose<DashboardData>(
    (ref) => ref.watch(dashboardRepositoryProvider).get());

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async        = ref.watch(_dashboardProvider);
    final canReport    = ref.watch(canViewReportsProvider).valueOrNull ?? false;
    final primary      = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.refresh),
            onPressed: () => ref.invalidate(_dashboardProvider),
          ),
        ],
      ),
      body: async.when(
        data: (d) => _Body(data: d, canReport: canReport, primary: primary),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

// ── Body ────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.data, required this.canReport, required this.primary});
  final DashboardData data;
  final bool  canReport;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // ── Özet chips ────────────────────────────────────────────────────
          _StatsRow(data: data),
          const SizedBox(height: 20),

          // ── Hızlı Erişim ─────────────────────────────────────────────────
          const _SectionTitle('Hızlı Erişim'),
          const SizedBox(height: 10),
          _QuickActions(canReport: canReport),
          const SizedBox(height: 20),

          // ── Son Teklifler ─────────────────────────────────────────────────
          const _SectionTitle('Son Teklifler'),
          const SizedBox(height: 10),
          if (data.recentQuotes.isEmpty)
            const _EmptyCard('Henüz teklif bulunmuyor.')
          else
            ...data.recentQuotes.map((q) => _RecentQuoteTile(quote: q)),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => context.go(AppRoutes.quotes),
            child: const Text('Tüm teklifleri gör →'),
          ),
        ],
      ),
    );
  }
}

// ── Üst istatistik şeridi ────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.data});
  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Toplam',
          value: '${data.totalQuotes}',
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Bekleyen',
          value: '${data.pendingQuotes}',
          color: AppColors.pending,
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Onaylanan',
          value: '${data.approvedQuotes}',
          color: AppColors.approved,
        ),
        if (data.todayVisits > 0) ...[
          const SizedBox(width: 8),
          _Chip(
            label: 'Ziyaret',
            value: '${data.todayVisits}',
            color: AppColors.info,
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.value, required this.color});
  final String label, value;
  final Color  color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: color.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
}

// ── Hızlı Erişim grid ────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.canReport});
  final bool canReport;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(icon: Symbols.add_circle, label: 'Yeni Teklif',   color: AppColors.approved,  route: AppRoutes.quoteNew),
      const _Action(icon: Symbols.person_add, label: 'Yeni Müşteri',  color: AppColors.info,       route: AppRoutes.customerNew),
      _Action(icon: Symbols.calendar_add_on, label: 'Ziyaret Planla', color: AppColors.pending, route: AppRoutes.visitPlans),
      const _Action(icon: Symbols.view_kanban, label: 'Kanban',        color: Colors.purple,        route: AppRoutes.kanban),
      const _Action(icon: Symbols.people,     label: 'Müşteriler',     color: Colors.teal,          route: AppRoutes.customers),
      const _Action(icon: Symbols.description,label: 'Teklifler',      color: Colors.indigo,        route: AppRoutes.quotes),
      if (canReport)
        const _Action(icon: Symbols.bar_chart, label: 'Raporlar',      color: Colors.orange,        route: AppRoutes.reports),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) => _ActionTile(action: actions[i]),
    );
  }
}

class _Action {
  const _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
  final IconData icon;
  final String   label, route;
  final Color    color;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});
  final _Action action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(action.route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, size: 22, color: action.color, fill: 1),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Son Teklifler ────────────────────────────────────────────────────────────

class _RecentQuoteTile extends StatelessWidget {
  const _RecentQuoteTile({required this.quote});
  final RecentQuote quote;

  static final _statusColors = <int, Color>{
    0: AppColors.info,
    1: AppColors.pending,
    2: AppColors.approved,
    3: AppColors.error,
    4: Colors.grey,
  };
  static const _statusLabels = {
    0: 'Taslak',
    1: 'Gönderildi',
    2: 'Onaylandı',
    3: 'Reddedildi',
    4: 'Süresi Doldu',
  };

  @override
  Widget build(BuildContext context) {
    final color = _statusColors[quote.status] ?? Colors.grey;
    final label = _statusLabels[quote.status] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.quoteNumber,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  quote.customerName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d MMM yy', 'tr_TR').format(quote.date.toLocal()),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Yardımcı widgetlar ────────────────────────────────────────────────────────

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

class _EmptyCard extends StatelessWidget {
  const _EmptyCard(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        ),
      );
}
