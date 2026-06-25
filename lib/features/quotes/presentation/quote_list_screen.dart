import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/skeleton.dart';
import '../data/quote_model.dart';
import '../data/quote_repository.dart';
import 'quote_providers.dart';

final _fmt = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

enum _Filter { all, approved, pending }
enum _Sort   { dateDesc, dateAsc, totalDesc, totalAsc }

extension _FilterLabel on _Filter {
  String get label => switch (this) {
    _Filter.all      => 'Tümü',
    _Filter.approved => 'Onaylandı',
    _Filter.pending  => 'Bekliyor',
  };
}

extension _SortLabel on _Sort {
  String get label => switch (this) {
    _Sort.dateDesc  => 'En Yeni',
    _Sort.dateAsc   => 'En Eski',
    _Sort.totalDesc => 'Tutar ↓',
    _Sort.totalAsc  => 'Tutar ↑',
  };
  IconData get icon => switch (this) {
    _Sort.dateDesc  => Symbols.arrow_downward,
    _Sort.dateAsc   => Symbols.arrow_upward,
    _Sort.totalDesc => Symbols.arrow_downward,
    _Sort.totalAsc  => Symbols.arrow_upward,
  };
}

class QuoteListScreen extends ConsumerStatefulWidget {
  const QuoteListScreen({super.key, this.customerId});
  final String? customerId;

  @override
  ConsumerState<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends ConsumerState<QuoteListScreen> {
  final _search    = TextEditingController();
  String  _searchText = '';
  _Filter _filter     = _Filter.all;
  _Sort   _sort       = _Sort.dateDesc;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<QuoteSummary> _apply(List<QuoteSummary> raw) {
    var list = raw.where((q) => switch (_filter) {
      _Filter.all      => true,
      _Filter.approved => q.isApproved,
      _Filter.pending  => !q.isApproved,
    }).toList();

    list.sort((a, b) => switch (_sort) {
      _Sort.dateDesc  => b.createdAt.compareTo(a.createdAt),
      _Sort.dateAsc   => a.createdAt.compareTo(b.createdAt),
      _Sort.totalDesc => b.grandTotal.compareTo(a.grandTotal),
      _Sort.totalAsc  => a.grandTotal.compareTo(b.grandTotal),
    });

    return list;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Sıralama',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
            ..._Sort.values.map((s) => ListTile(
              leading: Icon(s.icon, size: 20),
              title: Text(s.label),
              trailing: _sort == s
                  ? Icon(Symbols.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                setState(() => _sort = s);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportExcel() async {
    try {
      final dio  = ref.read(dioProvider);
      final res  = await dio.get('/quotes/export/excel',
          options: Options(responseType: ResponseType.bytes));

      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/teklifler.xlsx');
      await file.writeAsBytes(res.data as List<int>);

      await Share.shareXFiles([XFile(file.path)],
          text: 'TeklifApp — Teklif Listesi');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel dışa aktarma başarısız.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final async   = ref.watch(allQuotesProvider(
      customerId: widget.customerId,
      search: _searchText.isEmpty ? null : _searchText,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teklifler'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Symbols.view_kanban),
            tooltip: 'Kanban Görünümü',
            onPressed: () => context.push('/kanban'),
          ),
          IconButton(
            icon: const Icon(Symbols.table_view),
            tooltip: 'Excel İndir',
            onPressed: _exportExcel,
          ),
          // Sıralama butonu
          IconButton(
            icon: const Icon(Symbols.sort),
            tooltip: 'Sıralama',
            onPressed: _showSortSheet,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filled(
              icon: const Icon(Symbols.add, size: 22),
              tooltip: 'Yeni Teklif',
              onPressed: () => context.push('/quotes/new'),
              style: IconButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Teklif ara...',
                prefixIcon: const Icon(Symbols.search, size: 20),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Symbols.close, size: 18),
                        onPressed: () {
                          _search.clear();
                          setState(() => _searchText = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtre chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _Filter.values.map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : null,
                        )),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: primary,
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),

          // Liste
          Expanded(
            child: async.when(
              data: (paged) {
                final quotes = _apply(paged.items);
                if (quotes.isEmpty) {
                  return _EmptyState(
                    hasSearch: _searchText.isNotEmpty,
                    hasFilter: _filter != _Filter.all,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(allQuotesProvider(
                    customerId: widget.customerId,
                    search: _searchText.isEmpty ? null : _searchText,
                  ).future),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: quotes.length,
                    itemBuilder: (ctx, i) => _DismissibleQuote(
                      quote: quotes[i],
                      customerId: widget.customerId,
                      searchText: _searchText,
                      ref: ref,
                    ),
                  ),
                );
              },
              loading: () => const SkeletonList(),
              error: (e, _) => _ErrorState(
                message: '$e',
                onRetry: () => ref.invalidate(allQuotesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DismissibleQuote extends ConsumerWidget {
  const _DismissibleQuote({
    required this.quote,
    required this.customerId,
    required this.searchText,
    required this.ref,
  });
  final QuoteSummary quote;
  final String?      customerId;
  final String       searchText;
  final WidgetRef    ref;

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    if (quote.isApproved) {
      return _QuoteCard(
        quote: quote,
        onTap: () => context.push('/quotes/${quote.id}'),
      );
    }

    return Dismissible(
      key: ValueKey(quote.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        HapticFeedback.mediumImpact();
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Teklifi İptal Et'),
            content: Text('"${quote.quoteNumberDisplay}" teklifini iptal etmek istiyor musunuz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Vazgeç'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('İptal Et'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) async {
        try {
          await widgetRef.read(quoteRepositoryProvider).cancel(quote.id);
          widgetRef.invalidate(allQuotesProvider(
            customerId: customerId,
            search: searchText.isEmpty ? null : searchText,
          ));
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Hata: $e')));
          }
        }
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error.shade600,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Symbols.cancel, color: Colors.white, fill: 1),
      ),
      child: _QuoteCard(
        quote: quote,
        onTap: () => context.push('/quotes/${quote.id}'),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.onTap});

  final QuoteSummary quote;
  final VoidCallback onTap;

  Color    get _statusColor => quote.isApproved ? AppColors.approved : AppColors.pending;
  Color    get _statusBg    => quote.isApproved ? AppColors.approvedBg : AppColors.pendingBg;
  IconData get _statusIcon  => quote.isApproved ? Symbols.check_circle : Symbols.pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_statusIcon, color: _statusColor, size: 22, fill: 1),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.quoteNumberDisplay,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${quote.formTemplateName}  ·  '
                      '${DateFormat('dd MMM yyyy').format(quote.createdAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt.format(quote.grandTotal),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      quote.isApproved ? 'Onaylandı' : 'Bekliyor',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasSearch, this.hasFilter = false});
  final bool hasSearch;
  final bool hasFilter;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Symbols.description,
                  size: 36, color: Colors.grey.shade400, fill: 1),
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch || hasFilter ? 'Sonuç bulunamadı.' : 'Henüz teklif yok.',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Text(
              hasSearch
                  ? 'Farklı anahtar kelime deneyin.'
                  : hasFilter
                      ? 'Bu filtrede teklif yok.'
                      : '"+" butonuyla ilk teklifinizi oluşturun.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String       message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.error.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Symbols.error, size: 36, color: AppColors.error, fill: 1),
            ),
            const SizedBox(height: 16),
            const Text('Bir hata oluştu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 18),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
}
