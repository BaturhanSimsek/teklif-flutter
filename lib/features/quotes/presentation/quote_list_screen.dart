import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../data/quote_model.dart';
import 'quote_providers.dart';

final _fmt = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

class QuoteListScreen extends ConsumerStatefulWidget {
  const QuoteListScreen({super.key, this.customerId});

  final String? customerId;

  @override
  ConsumerState<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends ConsumerState<QuoteListScreen> {
  final _search = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(allQuotesProvider(
      customerId: widget.customerId,
      search: _searchText.isEmpty ? null : _searchText,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teklifler'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filled(
              icon: const Icon(Symbols.add, size: 22),
              tooltip: 'Yeni Teklif',
              onPressed: () => context.push('/quotes/new'),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        data: (quotes) => quotes.isEmpty
            ? _EmptyState(hasSearch: _searchText.isNotEmpty)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(allQuotesProvider(
                  customerId: widget.customerId,
                  search: _searchText.isEmpty ? null : _searchText,
                ).future),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: quotes.length,
                  itemBuilder: (ctx, i) => _QuoteCard(
                    quote: quotes[i],
                    onTap: () => context.push('/quotes/${quotes[i].id}'),
                  ),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: '$e',
          onRetry: () => ref.invalidate(allQuotesProvider),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.onTap});

  final QuoteSummary quote;
  final VoidCallback onTap;

  Color get _statusColor => quote.isApproved ? AppColors.approved : AppColors.pending;
  Color get _statusBg    => quote.isApproved ? AppColors.approvedBg : AppColors.pendingBg;
  IconData get _statusIcon =>
      quote.isApproved ? Symbols.check_circle : Symbols.pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Durum ikonu
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

              // Teklif bilgisi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.quoteNumberDisplay,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${quote.formTemplateName}  ·  ${DateFormat('dd MMM yyyy').format(quote.createdAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Fiyat + durum badge
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
  const _EmptyState({required this.hasSearch});
  final bool hasSearch;

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
              child: Icon(Symbols.description, size: 36, color: Colors.grey.shade400, fill: 1),
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch ? 'Sonuç bulunamadı.' : 'Henüz teklif yok.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasSearch ? 'Farklı anahtar kelime deneyin.' : '"+" butonuyla ilk teklifinizi oluşturun.',
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
