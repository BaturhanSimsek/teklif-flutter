import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final async = ref.watch(customersProvider(search: _searchText.isEmpty ? null : _searchText));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteriler'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'İsim veya telefon ara...',
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await context.push<bool>('/customers/new');
          if (created == true) ref.invalidate(customersProvider);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Yeni Müşteri'),
      ),
      body: async.when(
        data: (list) => list.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline,
                        size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(
                      _searchText.isNotEmpty ? 'Sonuç bulunamadı.' : 'Henüz müşteri yok.',
                      style: TextStyle(color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(
                    customersProvider(search: _searchText.isEmpty ? null : _searchText).future),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _CustomerCard(customer: list[i]),
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
                onPressed: () => ref.invalidate(customersProvider),
                child: const Text('Tekrar dene'),
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => context.push('/customers/${customer.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                  style: TextStyle(
                      color: colors.onPrimaryContainer, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    if (customer.phone.isNotEmpty)
                      Text(customer.phone,
                          style: TextStyle(fontSize: 13, color: colors.outline)),
                    if (customer.email.isNotEmpty)
                      Text(customer.email,
                          style: TextStyle(fontSize: 12, color: colors.outline)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
