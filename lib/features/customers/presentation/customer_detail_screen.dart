import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/customer_model.dart';
import '../data/customer_repository.dart';
import 'customer_form_screen.dart';
import 'customer_providers.dart';
import '../../quotes/presentation/quote_list_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(customersProvider());

    return async.when(
      data: (list) {
        final customer = list.where((c) => c.id == customerId).firstOrNull;
        if (customer == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Müşteri bulunamadı.')),
          );
        }
        return _CustomerDetailView(customer: customer, ref: ref);
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
    );
  }
}

class _CustomerDetailView extends StatelessWidget {
  const _CustomerDetailView({required this.customer, required this.ref});

  final Customer customer;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Düzenle',
            onPressed: () async {
              final updated = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => CustomerFormScreen(existing: customer),
                ),
              );
              if (updated == true) ref.invalidate(customersProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Müşteri bilgi kartı
          Container(
            width: double.infinity,
            color: colors.surfaceVariant.withOpacity(0.4),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (customer.phone.isNotEmpty)
                  _InfoChip(Icons.phone_outlined, customer.phone),
                if (customer.email.isNotEmpty)
                  _InfoChip(Icons.email_outlined, customer.email),
                if (customer.address.isNotEmpty)
                  _InfoChip(Icons.location_on_outlined, customer.address),
                if (customer.taxNumber != null)
                  _InfoChip(Icons.numbers,
                      '${customer.taxNumber} / ${customer.taxOffice ?? ''}'),
                if (customer.notes != null)
                  _InfoChip(Icons.notes, customer.notes!),
              ],
            ),
          ),

          // Teklifler başlığı
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Text('Teklifler',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () => context.push(
                      '/quotes/new?customerId=${customer.id}&customerName=${Uri.encodeComponent(customer.name)}'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Yeni Teklif'),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          // Teklif listesi (customerId filtreli)
          Expanded(
            child: QuoteListScreen(customerId: customer.id),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.text);

  final IconData icon;
  final String   text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
      );
}
