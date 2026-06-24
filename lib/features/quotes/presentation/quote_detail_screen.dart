import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../data/pdf_service.dart';
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
      data: (q) => _QuoteDetailView(quote: q, ref: ref),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
    );
  }
}

class _QuoteDetailView extends StatelessWidget {
  const _QuoteDetailView({required this.quote, required this.ref});

  final QuoteDetail quote;
  final WidgetRef   ref;

  Future<void> _approve(BuildContext ctx, bool approve) async {
    try {
      await ref.read(quoteRepositoryProvider).approve(quote.id, approve: approve);
      ref.invalidate(quoteDetailProvider(quote.id));
    } catch (e) {
      if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _handlePdf(BuildContext ctx, String action) async {
    final svc = ref.read(pdfServiceProvider);
    try {
      if (action == 'share') {
        await svc.downloadAndShare(quote.id, quote.quoteNumberDisplay);
      } else if (action == 'pdf_open') {
        await svc.downloadAndOpen(quote.id, quote.quoteNumberDisplay);
      } else if (action == 'revise') {
        final newId = await ref.read(quoteRepositoryProvider).revise(quote.id);
        if (ctx.mounted) ctx.pushReplacement('/quotes/$newId');
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary     = Theme.of(context).colorScheme.primary;
    final statusColor = quote.isApproved ? AppColors.approved : AppColors.pending;
    final statusBg    = quote.isApproved ? AppColors.approvedBg : AppColors.pendingBg;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar — gradient header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: primary,
            foregroundColor: Colors.white,
            actions: [
              if (!quote.isApproved)
                IconButton(
                  icon: const Icon(Symbols.check_circle, fill: 1),
                  tooltip: 'Onayla',
                  onPressed: () => _approve(context, true),
                ),
              if (quote.isApproved)
                IconButton(
                  icon: const Icon(Symbols.cancel, fill: 1),
                  tooltip: 'Onayı Geri Al',
                  onPressed: () => _approve(context, false),
                ),
              // PDF hızlı paylaş butonu
              IconButton(
                icon: const Icon(Symbols.ios_share),
                tooltip: 'PDF Paylaş',
                onPressed: () => _handlePdf(context, 'share'),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Symbols.more_vert),
                onSelected: (v) => _handlePdf(context, v),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'pdf_open',
                    child: Row(children: [
                      Icon(Symbols.picture_as_pdf, size: 18),
                      SizedBox(width: 10),
                      Text('PDF Görüntüle'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(children: [
                      Icon(Symbols.share, size: 18),
                      SizedBox(width: 10),
                      Text('PDF Paylaş'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'revise',
                    child: Row(children: [
                      Icon(Symbols.edit_document, size: 18),
                      SizedBox(width: 10),
                      Text('Yeni Revizyon'),
                    ]),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary.withOpacity(0.85), primary],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          quote.quoteNumberDisplay,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                quote.isApproved ? 'Onaylandı' : 'Bekliyor',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _curr.format(quote.grandTotal),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // İçerik
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Müşteri kartı
                _InfoCard(
                  title: 'Müşteri',
                  icon: Symbols.person,
                  rows: [
                    _Row('Ad',      quote.customerName),
                    _Row('Telefon', quote.customerPhone),
                  ],
                ),
                const SizedBox(height: 12),

                // Teklif bilgileri
                _InfoCard(
                  title: 'Teklif Bilgileri',
                  icon: Symbols.info,
                  rows: [
                    _Row('Tarih',    DateFormat('dd.MM.yyyy').format(quote.date)),
                    _Row('Ödeme',    quote.paymentTerm),
                    _Row('Teslimat', '${quote.deliveryDays} gün'),
                    _Row('İndirim',  '%${quote.discountRate.toStringAsFixed(0)}'),
                    _Row('KDV',      '%${quote.kdvRate.toStringAsFixed(0)}'),
                    if (quote.notes != null) _Row('Notlar', quote.notes!),
                  ],
                ),
                const SizedBox(height: 16),

                // Kalemler başlık
                Row(
                  children: [
                    Icon(Symbols.list, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text('Kalemler',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                ...quote.items.map((item) => _ItemCard(item: item)),
                const SizedBox(height: 12),

                // Toplamlar
                _TotalsCard(quote: quote),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Yardımcı modeller ────────────────────────────────────────────────────────

class _Row {
  const _Row(this.label, this.value);
  final String label, value;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.icon, required this.rows});
  final String      title;
  final IconData    icon;
  final List<_Row>  rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary, fill: 1),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ]),
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 12),
            ...rows.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(r.label,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                      ),
                      Expanded(
                        child: Text(r.value,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});
  final QuoteItemDetail item;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          Row(children: [
            Text('${item.quantity} ${item.unit}  ×  ${_curr.format(item.unitPrice)}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            const Spacer(),
            Text(_curr.format(item.total),
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.w700, fontSize: 14)),
          ]),
          if (item.customFields.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.customFields.entries
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${e.key}: ${e.value}',
                            style: TextStyle(
                                fontSize: 11,
                                color: primary,
                                fontWeight: FontWeight.w500)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.quote});
  final QuoteDetail quote;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _TotalRow('Ara Toplam', _curr.format(quote.subTotal)),
          if (quote.discountRate > 0)
            _TotalRow(
              'İndirim (%${quote.discountRate.toStringAsFixed(0)})',
              '-${_curr.format(quote.discountAmount)}',
              valueColor: AppColors.success,
            ),
          _TotalRow('KDV (%${quote.kdvRate.toStringAsFixed(0)})',
              _curr.format(quote.kdvAmount)),
          Divider(height: 20, color: Colors.grey.shade200),
          _TotalRow(
            'GENEL TOPLAM',
            _curr.format(quote.grandTotal),
            bold: true,
            valueColor: primary,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(this.label, this.value, {this.bold = false, this.valueColor});
  final String label, value;
  final bool   bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
                    color: bold ? null : Colors.grey.shade500)),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontSize: bold ? 16 : 13,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                    color: valueColor)),
          ],
        ),
      );
}
