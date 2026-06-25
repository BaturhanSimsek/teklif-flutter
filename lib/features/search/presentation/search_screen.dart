import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/customers/data/customer_model.dart';
import '../../../features/customers/data/customer_repository.dart';
import '../../../features/products/data/product_model.dart';
import '../../../features/products/data/product_repository.dart';
import '../../../features/quotes/data/quote_model.dart';
import '../../../features/quotes/data/quote_repository.dart';

final _curr = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  Timer?  _debounce;
  String  _query    = '';
  bool    _loading  = false;

  List<QuoteSummary> _quotes    = [];
  List<Customer>     _customers = [];
  List<Product>      _products  = [];

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() { _query = ''; _quotes = []; _customers = []; _products = []; });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value.trim()));
  }

  Future<void> _search(String q) async {
    setState(() { _loading = true; _query = q; });
    try {
      final results = await Future.wait([
        ref.read(quoteRepositoryProvider).getAll(search: q),
        ref.read(customerRepositoryProvider).getAll(search: q),
        ref.read(productRepositoryProvider).getAll(search: q),
      ]);
      if (mounted) {
        final qPaged = results[0] as dynamic;
        final cPaged = results[1] as dynamic;
        final pPaged = results[2] as dynamic;
        setState(() {
          _quotes    = (qPaged.items  as List<QuoteSummary>).take(5).toList();
          _customers = (cPaged.items  as List<Customer>).take(5).toList();
          _products  = (pPaged.items  as List<Product>)
              .where((p) => p.isActive).take(5).toList();
          _loading   = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _hasResults =>
      _quotes.isNotEmpty || _customers.isNotEmpty || _products.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: TextField(
          controller: _ctrl,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Teklif, müşteri, ürün ara...',
            prefixIcon: const Icon(Symbols.search, size: 20),
            suffixIcon: _ctrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Symbols.close, size: 18),
                    onPressed: () {
                      _ctrl.clear();
                      _onChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            isDense: true,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _query.isEmpty
              ? _IdleState(primary: primary)
              : !_hasResults
                  ? const _EmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      children: [
                        if (_quotes.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Symbols.description,
                            title: 'Teklifler',
                            color: primary,
                            onSeeAll: () => context.go(
                                '/quotes?search=${Uri.encodeQueryComponent(_query)}'),
                          ),
                          ..._quotes.map((q) => _QuoteResult(quote: q)),
                          const SizedBox(height: 16),
                        ],
                        if (_customers.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Symbols.people,
                            title: 'Müşteriler',
                            color: primary,
                            onSeeAll: () => context.go('/customers'),
                          ),
                          ..._customers.map((c) => _CustomerResult(customer: c)),
                          const SizedBox(height: 16),
                        ],
                        if (_products.isNotEmpty) ...[
                          _SectionHeader(
                            icon: Symbols.inventory_2,
                            title: 'Ürünler',
                            color: primary,
                            onSeeAll: () => context.go('/admin/products'),
                          ),
                          ..._products.map((p) => _ProductResult(product: p)),
                        ],
                      ],
                    ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    required this.onSeeAll,
  });
  final IconData     icon;
  final String       title;
  final Color        color;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const Spacer(),
            GestureDetector(
              onTap: onSeeAll,
              child: Text('Tümünü gör',
                  style: TextStyle(fontSize: 12, color: color)),
            ),
          ],
        ),
      );
}

// ── Quote Result ─────────────────────────────────────────────────────────────

class _QuoteResult extends StatelessWidget {
  const _QuoteResult({required this.quote});
  final QuoteSummary quote;

  @override
  Widget build(BuildContext context) {
    final color = quote.isApproved ? AppColors.approved : AppColors.pending;
    final bg    = quote.isApproved ? AppColors.approvedBg : AppColors.pendingBg;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(
          quote.isApproved ? Symbols.check_circle : Symbols.pending,
          size: 18, color: color, fill: 1,
        ),
      ),
      title: Text(quote.quoteNumberDisplay,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(
        _curr.format(quote.grandTotal),
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
      trailing: Text(
        quote.isApproved ? 'Onaylandı' : 'Bekliyor',
        style: TextStyle(fontSize: 11, color: color),
      ),
      onTap: () => context.push('/quotes/${quote.id}'),
    );
  }
}

// ── Customer Result ──────────────────────────────────────────────────────────

class _CustomerResult extends StatelessWidget {
  const _CustomerResult({required this.customer});
  final Customer customer;

  static List<Color> get _colors => AppColors.avatarPalette;

  @override
  Widget build(BuildContext context) {
    final c = _colors[customer.name.codeUnitAt(0) % _colors.length];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        radius: 19,
        backgroundColor: c.withOpacity(0.15),
        child: Text(
          customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
          style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      title: Text(customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: customer.phone.isNotEmpty
          ? Text(customer.phone,
              style: const TextStyle(fontSize: 12, color: Colors.grey))
          : null,
      onTap: () => context.push('/customers/${customer.id}'),
    );
  }
}

// ── Product Result ───────────────────────────────────────────────────────────

class _ProductResult extends StatelessWidget {
  const _ProductResult({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Symbols.inventory_2, size: 18, color: primary, fill: 1),
      ),
      title: Text(product.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(
          '${product.unitName ?? ''}${product.unitName != null ? '  ·  ' : ''}${_curr.format(product.salePrice)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      onTap: () => context.push('/admin/products'),
    );
  }
}

// ── States ───────────────────────────────────────────────────────────────────

class _IdleState extends StatelessWidget {
  const _IdleState({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Symbols.search, size: 36, color: primary.withOpacity(0.5)),
            ),
            const SizedBox(height: 16),
            Text('Arama yapın',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            Text('Teklif, müşteri veya ürün adı girin',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Sonuç bulunamadı',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500)),
            const SizedBox(height: 6),
            Text('Farklı bir kelime deneyin',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      );
}
