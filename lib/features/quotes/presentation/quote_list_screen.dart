import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/quote_model.dart';
import 'quote_providers.dart';

final _fmt = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

class QuoteListScreen extends ConsumerWidget {
  const QuoteListScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(quotesByCustomerProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teklifler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/quotes/new?customerId=$customerId'),
          ),
        ],
      ),
      body: async.when(
        data: (quotes) => quotes.isEmpty
            ? const Center(child: Text('Henüz teklif yok.'))
            : RefreshIndicator(
                onRefresh: () => ref.refresh(quotesByCustomerProvider(customerId).future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quotes.length,
                  itemBuilder: (ctx, i) => _QuoteCard(
                    quote: quotes[i],
                    onTap: () => context.push('/quotes/${quotes[i].id}'),
                  ),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.onTap});

  final QuoteSummary quote;
  final VoidCallback  onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: quote.isApproved
              ? colors.primaryContainer
              : colors.surfaceVariant,
          child: Icon(
            quote.isApproved ? Icons.check_circle : Icons.description,
            color: quote.isApproved ? colors.primary : colors.outline,
          ),
        ),
        title: Text(
          quote.quoteNumberDisplay,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${quote.formTemplateName}  •  ${DateFormat('dd.MM.yyyy').format(quote.createdAt)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _fmt.format(quote.grandTotal),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.primary,
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
                  style: TextStyle(fontSize: 11, color: colors.onPrimaryContainer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
