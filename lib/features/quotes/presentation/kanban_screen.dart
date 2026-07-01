import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../data/kanban_model.dart';
import '../data/quote_repository.dart';

const _kColWidth = 240.0;
const _kColGap   = 8.0;

class _ColDef {
  final int      status;
  final String   label;
  final String   stage;
  final Color    color;
  final Color    bgColor;
  final IconData icon;
  const _ColDef({
    required this.status,
    required this.label,
    required this.stage,
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}

const _cols = [
  _ColDef(status: 1, label: 'Taslak',       stage: 'Draft',    color: Color(0xFF78909C), bgColor: Color(0xFFECEFF1), icon: Symbols.draft),
  _ColDef(status: 2, label: 'Gönderildi',   stage: 'Sent',     color: Color(0xFF0278D6), bgColor: Color(0xFFE1EFFA), icon: Symbols.send),
  _ColDef(status: 3, label: 'Onaylandı',    stage: 'Approved', color: Color(0xFF0AA553), bgColor: Color(0xFFE2F4EA), icon: Symbols.check_circle),
  _ColDef(status: 4, label: 'Reddedildi',   stage: 'Rejected', color: Color(0xFFE0302A), bgColor: Color(0xFFFBE6E5), icon: Symbols.cancel),
  _ColDef(status: 5, label: 'Süresi Doldu', stage: 'Expired',  color: Color(0xFFED9200), bgColor: Color(0xFFFDF2E0), icon: Symbols.timer_off),
];

String _fmt(double amount, String currency) {
  switch (currency) {
    case 'USD': return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
    case 'EUR': return NumberFormat.currency(locale: 'de_DE', symbol: '€').format(amount);
    default:    return NumberFormat.currency(locale: 'tr_TR', symbol: '₺').format(amount);
  }
}

class KanbanScreen extends ConsumerStatefulWidget {
  const KanbanScreen({super.key});

  @override
  ConsumerState<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends ConsumerState<KanbanScreen> {
  final _lists = <int, List<KanbanCard>>{
    1: [], 2: [], 3: [], 4: [], 5: [],
  };
  bool    _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final board = await ref.read(quoteRepositoryProvider).getKanban();
      setState(() {
        _lists[1] = List.of(board.draft);
        _lists[2] = List.of(board.sent);
        _lists[3] = List.of(board.approved);
        _lists[4] = List.of(board.rejected);
        _lists[5] = List.of(board.expired);
        _loading  = false;
      });
    } catch (e) {
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  Future<void> _moveCard(KanbanCard card, _ColDef target) async {
    if (card.status == target.status) return;

    HapticFeedback.mediumImpact();

    // snapshot for rollback
    final snap = _lists.map((k, v) => MapEntry(k, List<KanbanCard>.of(v)));

    setState(() {
      _lists[card.status]!.removeWhere((c) => c.id == card.id);
      _lists[target.status]!.insert(
        0,
        card.copyWith(status: target.status, isApproved: target.status == 3),
      );
    });

    try {
      await ref.read(quoteRepositoryProvider).moveStage(card.id, target.stage);
    } catch (e) {
      setState(() {
        for (final k in _lists.keys) {
          _lists[k] = snap[k]!;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Taşıma başarısız: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.refresh),
            tooltip: 'Yenile',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(onRetry: _load)
              : LayoutBuilder(
                  builder: (ctx, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: constraints.maxHeight - 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _cols
                            .map(
                              (col) => _KanbanColumn(
                                colDef: col,
                                cards:  _lists[col.status]!,
                                onDrop: (card) => _moveCard(card, col),
                                onTap:  (card) => context.push(AppRoutes.quoteDetail(card.id)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
    );
  }
}

// ── Column ────────────────────────────────────────────────────────────────────

class _KanbanColumn extends StatelessWidget {
  const _KanbanColumn({
    required this.colDef,
    required this.cards,
    required this.onDrop,
    required this.onTap,
  });

  final _ColDef                  colDef;
  final List<KanbanCard>         cards;
  final ValueChanged<KanbanCard> onDrop;
  final ValueChanged<KanbanCard> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kColWidth,
      margin: const EdgeInsets.only(right: _kColGap),
      decoration: BoxDecoration(
        color: colDef.bgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colDef.bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(colDef.icon, size: 17, color: colDef.color),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    colDef.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colDef.color,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: colDef.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${cards.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colDef.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Drop target
          Expanded(
            child: DragTarget<KanbanCard>(
              onWillAcceptWithDetails: (d) => d.data.status != colDef.status,
              onAcceptWithDetails:     (d) => onDrop(d.data),
              builder: (ctx, candidates, _) {
                final hovering = candidates.isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: hovering
                        ? colDef.color.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: cards.isEmpty
                      ? _EmptyCol(color: colDef.color, hovering: hovering)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                          itemCount: cards.length,
                          itemBuilder: (_, i) => _DraggableCard(
                            card:  cards[i],
                            color: colDef.color,
                            onTap: () => onTap(cards[i]),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty placeholder ──────────────────────────────────────────────────────────

class _EmptyCol extends StatelessWidget {
  const _EmptyCol({required this.color, required this.hovering});
  final Color color;
  final bool  hovering;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hovering ? Symbols.add_circle : Symbols.inbox,
              size: 36,
              color: color.withValues(alpha: hovering ? 0.8 : 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              hovering ? 'Buraya Bırak' : 'Boş',
              style: TextStyle(
                color: color.withValues(alpha: hovering ? 0.8 : 0.3),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
}

// ── Draggable card ─────────────────────────────────────────────────────────────

class _DraggableCard extends StatelessWidget {
  const _DraggableCard({
    required this.card,
    required this.color,
    required this.onTap,
  });
  final KanbanCard   card;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = _CardContent(card: card, color: color, onTap: onTap);

    return LongPressDraggable<KanbanCard>(
      data:  card,
      delay: const Duration(milliseconds: 300),
      feedback: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: _kColWidth - 16,
          child: _CardContent(card: card, color: color, onTap: () {}),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: content),
      child: content,
    );
  }
}

// ── Card content ───────────────────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  const _CardContent({required this.card, required this.color, required this.onTap});
  final KanbanCard   card;
  final Color        color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    card.quoteNumberDisplay,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (card.viewCount > 0) ...[
                  const SizedBox(width: 4),
                  Icon(Symbols.visibility, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 2),
                  Text(
                    '${card.viewCount}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              card.customerName,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fmt(card.grandTotal, card.currency),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: color,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(card.createdAt),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ─────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.error, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            const Text(
              'Veriler yüklenemedi',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 18),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
}
