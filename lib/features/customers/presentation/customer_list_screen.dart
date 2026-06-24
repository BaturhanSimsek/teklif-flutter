import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../data/customer_model.dart';
import 'customer_providers.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _search = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final async   = ref.watch(customersProvider(
        search: _searchText.isEmpty ? null : _searchText));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteriler'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'İsim veya telefon ara...',
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
              icon: const Icon(Symbols.person_add, size: 20),
              tooltip: 'Yeni Müşteri',
              onPressed: () async {
                final created = await context.push<bool>('/customers/new');
                if (created == true) ref.invalidate(customersProvider);
              },
              style: IconButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        data: (list) => list.isEmpty
            ? _EmptyState(hasSearch: _searchText.isNotEmpty)
            : RefreshIndicator(
                onRefresh: () => ref.refresh(customersProvider(
                    search: _searchText.isEmpty ? null : _searchText).future),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _CustomerCard(customer: list[i]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Symbols.error, size: 48, color: Color(0xFFE0302A), fill: 1),
              const SizedBox(height: 12),
              Text('$e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(customersProvider),
                icon: const Icon(Symbols.refresh, size: 18),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});
  final Customer customer;

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
    final color = _avatarColor(customer.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => context.push('/customers/${customer.id}'),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Bilgiler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    if (customer.phone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Symbols.call, size: 13, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(customer.phone,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ]),
                    ],
                    if (customer.email.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Row(children: [
                        Icon(Symbols.mail, size: 13, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(customer.email,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ]),
                    ],
                  ],
                ),
              ),

              Icon(Symbols.chevron_right, color: Colors.grey.shade400, size: 20),
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
              child: Icon(Symbols.people, size: 36, color: Colors.grey.shade400, fill: 1),
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch ? 'Sonuç bulunamadı.' : 'Henüz müşteri yok.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Text(
              hasSearch ? 'Farklı anahtar kelime deneyin.' : '"+" butonuyla ilk müşterinizi ekleyin.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
}
