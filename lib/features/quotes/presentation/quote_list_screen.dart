import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Teklif no ara...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _search.clear();
                          setState(() => _searchText = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Yeni Teklif',
            onPressed: () => context.push('/quotes/new'),
          ),
        ],
      ),
      body: async.when(
        data: (quotes) => quotes.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined,
                        size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(
                      _searchText.isNotEmpty ? 'Sonuç bulunamadı.' : 'Henüz teklif yok.',
                      style: TextStyle(color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(allQuotesProvider(
                  customerId: widget.customerId,
                  search: _searchText.isEmpty ? null : _searchText,
                ).future),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  itemCount: quotes.length,
                  itemBuilder: (ctx, i) => _QuoteCard(
                    quote: quotes[i],
                    onTap: () => context.push('/quotes/${quotes[i].id}'),
                  ),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(allQuotesProvider),
                child: const Text('Tekrar dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.onTap});

  final QuoteSummary quote;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: quote.isApproved
                    ? colors.primaryContainer
                    : colors.surfaceVariant,
                child: Icon(
                  quote.isApproved ? Icons.check_circle : Icons.description,
                  color: quote.isApproved ? colors.primary : colors.outline,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.quoteNumberDisplay,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${quote.formTemplateName}  •  ${DateFormat('dd.MM.yyyy').format(quote.createdAt)}',
                      style: TextStyle(fontSize: 12, color: colors.outline),
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
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                      fontSize: 14,
                    ),
                  ),
                  if (quote.isApproved)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Onaylandı',
                        style: TextStyle(fontSize: 10, color: colors.onPrimaryContainer),
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
