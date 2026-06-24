import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/quote_model.dart';
import '../data/quote_repository.dart';
import 'quote_providers.dart';

final _curr = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

class QuoteDetailScreen extends ConsumerWidget {
  const QuoteDetailScreen({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(quoteDetailProvider(quoteId));

    return async.when(
      data: (q) => Scaffold(
        appBar: AppBar(
          title: Text(q.quoteNumberDisplay),
          actions: [
            if (!q.isApproved)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Onayla',
                onPressed: () => _approve(context, ref, q.id, true),
              ),
            if (q.isApproved)
              IconButton(
                icon: const Icon(Icons.cancel_outlined),
                tooltip: 'Onayı Geri Al',
                onPressed: () => _approve(context, ref, q.id, false),
              ),
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'revise') {
                  final newId = await ref.read(quoteRepositoryProvider).revise(q.id);
                  if (context.mounted) context.pushReplacement('/quotes/$newId');
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'revise', child: Text('Yeni Revizyon')),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCard(title: 'Müşteri', children: [
                _InfoRow('Ad',      q.customerName),
                _InfoRow('Telefon', q.customerPhone),
              ]),
              const SizedBox(height: 12),
              _SectionCard(title: 'Teklif Bilgileri', children: [
                _InfoRow('Tarih',     DateFormat('dd.MM.yyyy').format(q.date)),
                _InfoRow('Ödeme',     q.paymentTerm),
                _InfoRow('Teslimat',  '${q.deliveryDays} gün'),
                _InfoRow('İndirim',   '%${q.discountRate.toStringAsFixed(0)}'),
                _InfoRow('KDV',       '%${q.kdvRate.toStringAsFixed(0)}'),
                if (q.notes != null) _InfoRow('Notlar', q.notes!),
              ]),
              const SizedBox(height: 12),
              Text('Kalemler', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...q.items.map((item) => _ItemCard(item: item)),
              const SizedBox(height: 12),
              _TotalsCard(quote: q),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:   (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
    );
  }

  Future<void> _approve(BuildContext ctx, WidgetRef ref, String id, bool approve) async {
    try {
      await ref.read(quoteRepositoryProvider).approve(id, approve: approve);
      ref.invalidate(quoteDetailProvider(id));
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String       title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const Divider(height: 12),
              ...children,
            ],
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(label, style: const TextStyle(color: Colors.grey)),
            ),
            Expanded(
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});
  final QuoteItemDetail item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: colors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Row(children: [
              Text('${item.quantity} ${item.unit}  ×  ${_curr.format(item.unitPrice)}'),
              const Spacer(),
              Text(_curr.format(item.total),
                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
            ]),
            if (item.customFields.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: item.customFields.entries
                    .map((e) => Chip(
                          label: Text('${e.key}: ${e.value}'),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.quote});
  final QuoteDetail quote;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _TotalRow('Ara Toplam', _curr.format(quote.subTotal)),
            if (quote.discountRate > 0)
              _TotalRow(
                'İndirim (${quote.discountRate.toStringAsFixed(0)}%)',
                '-${_curr.format(quote.discountAmount)}',
                color: Colors.green,
              ),
            _TotalRow('KDV (${quote.kdvRate.toStringAsFixed(0)}%)', _curr.format(quote.kdvAmount)),
            const Divider(),
            _TotalRow(
              'GENEL TOPLAM',
              _curr.format(quote.grandTotal),
              bold: true,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(this.label, this.value, {this.bold = false, this.color});
  final String label, value;
  final bool   bold;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color)),
          ],
        ),
      );
}
