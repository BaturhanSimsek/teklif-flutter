import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/quote_model.dart';
import '../data/quote_repository.dart';

part 'quote_revisions_screen.g.dart';

@riverpod
Future<List<QuoteSummary>> quoteRevisions(QuoteRevisionsRef ref, String quoteId) =>
    ref.watch(quoteRepositoryProvider).getRevisions(quoteId);

class QuoteRevisionsScreen extends ConsumerWidget {
  const QuoteRevisionsScreen({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(quoteRevisionsProvider(quoteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Revizyon Geçmişi')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (revisions) => revisions.isEmpty
            ? const Center(child: Text('Revizyon bulunamadı'))
            : ListView.separated(
                itemCount: revisions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final r = revisions[i];
                  final isActive = r.id == quoteId;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive
                          ? Theme.of(ctx).colorScheme.primary
                          : Colors.grey.shade200,
                      foregroundColor: isActive ? Colors.white : Colors.black87,
                      child: Text('R${r.revisionNo}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    title: Text(r.quoteNumberDisplay,
                        style: isActive
                            ? const TextStyle(fontWeight: FontWeight.w700)
                            : null),
                    subtitle: Text(
                        DateFormat('dd.MM.yyyy').format(r.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusChip(r.status, r.isApproved),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(locale: 'tr_TR', symbol: '₺')
                              .format(r.grandTotal),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!isActive) ctx.pushReplacement('/quotes/${r.id}');
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.status, this.isApproved);

  final int status;
  final bool isApproved;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      0 => ('Taslak', Colors.grey),
      1 => ('Gönderildi', Colors.blue),
      2 => ('Onaylandı', Colors.green),
      3 => ('Reddedildi', Colors.red),
      _ => ('Bilinmiyor', Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
