import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/theme/app_colors.dart';
import '../data/product_model.dart';
import '../data/product_repository.dart';
import 'product_form_screen.dart';

final _productsProvider = FutureProvider.autoDispose<List<Product>>(
    (ref) => ref.watch(productRepositoryProvider).getAll());

final _curr = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_productsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Ürün Kataloğu'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProductFormScreen()));
          ref.invalidate(_productsProvider);
        },
        icon: const Icon(Symbols.add),
        label: const Text('Yeni Ürün'),
      ),
      body: async.when(
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(_productsProvider.future),
          child: _ProductList(products: list, ref: ref),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products, required this.ref});
  final List<Product> products;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final active = products.where((p) => p.isActive).toList();

    if (active.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.inventory_2, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('Henüz ürün yok', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: active.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _ProductCard(product: active[i], ref: ref),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.ref});
  final Product product;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Symbols.inventory_2, color: primary, size: 24, fill: 1),
        ),
        title: Text(product.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text('Birim: ${product.unit}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (product.categoryName != null)
              Text(product.categoryName!,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_curr.format(product.salePrice),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: primary)),
            if (product.purchasePrice > 0)
              Text('Maliyet: ${_curr.format(product.purchasePrice)}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductFormScreen(product: product)),
          );
          ref.invalidate(_productsProvider);
        },
        onLongPress: () => _confirmDelete(context),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ürünü Sil'),
        content: Text('"${product.name}" ürününü silmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(productRepositoryProvider).delete(product.id);
      ref.invalidate(_productsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }
}
