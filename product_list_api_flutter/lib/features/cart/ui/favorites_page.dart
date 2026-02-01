import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/state/cart_provider.dart';
import '../../products/state/favorites_provider.dart';
import '../../products/state/products_pagination_provider.dart';
import '../../products/ui/product_details_page.dart';
import '../../products/ui/widgets/product_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final productsState = ref.watch(productsNotifierProvider);

    final favProducts = productsState.items.where((p) => favIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          if (favIds.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(favoritesProvider.notifier).clear(),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: favProducts.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final p = favProducts[i];
                return ProductCard(
                  product: p,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
                    );
                  },
                  onAddToCart: () async {
                    await ref.read(cartProvider.notifier).add(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to cart: ${p.title}')),
                    );
                  },
                );
              },
            ),
    );
  }
}
