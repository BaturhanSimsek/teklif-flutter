import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../data/customer_model.dart';
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

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFF5C6BC0), const Color(0xFF26A69A), const Color(0xFFEF5350),
      const Color(0xFFAB47BC), const Color(0xFF42A5F5), const Color(0xFFFF7043),
      const Color(0xFF66BB6A), const Color(0xFFEC407A),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final color   = _avatarColor(customer.name);

    return Scaffold(
      body: Column(
        children: [
          // Header gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.75), color],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // AppBar row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Symbols.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Symbols.edit, color: Colors.white, size: 20),
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
                  ),

                  // Avatar + isim
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (customer.email.isNotEmpty)
                                Text(
                                  customer.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // İletişim bilgileri chips
          if (customer.phone.isNotEmpty || customer.address.isNotEmpty || customer.taxNumber != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (customer.phone.isNotEmpty)
                    _InfoChip(icon: Symbols.call, text: customer.phone),
                  if (customer.address.isNotEmpty)
                    _InfoChip(icon: Symbols.location_on, text: customer.address),
                  if (customer.taxNumber != null)
                    _InfoChip(
                      icon: Symbols.tag,
                      text: '${customer.taxNumber} / ${customer.taxOffice ?? ''}',
                    ),
                  if (customer.notes != null)
                    _InfoChip(icon: Symbols.notes, text: customer.notes!),
                ],
              ),
            ),

          // Teklifler başlık + buton
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Text('Teklifler',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const Spacer(),
                MaterialButton(
                  onPressed: () => context.push(
                      '/quotes/new?customerId=${customer.id}&customerName=${Uri.encodeComponent(customer.name)}'),
                  color: primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.add, size: 18, color: primary),
                      const SizedBox(width: 6),
                      Text('Yeni Teklif',
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Teklif listesi
          Expanded(
            child: QuoteListScreen(customerId: customer.id),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});
  final IconData icon;
  final String   text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500, fill: 1),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}
