import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/cart_badge_button.dart';
import '../../cart/state/cart_provider.dart';
import '../state/categories_provider.dart';
import '../state/products_pagination_provider.dart';
import '../state/search_providers.dart';
import '../state/search_results_provider.dart';
import '../state/sort_provider.dart';
import '../state/sort_utils.dart';
import '../../cart/ui/favorites_page.dart';
import 'product_details_page.dart';
import 'widgets/product_card.dart';
import 'widgets/product_list_skeleton.dart';
import 'widgets/products_error_view.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(isSearchingProvider.notifier).state = false;
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              )
            : null,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
              )
            : const Text('ShopLite'),
        actions: [
          if (!isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => ref.read(isSearchingProvider.notifier).state = true,
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
            ),
            PopupMenuButton<ProductSort>(
              initialValue: ref.watch(productSortProvider),
              onSelected: (v) => ref.read(productSortProvider.notifier).state = v,
              itemBuilder: (context) => const [
                PopupMenuItem(value: ProductSort.none, child: Text('Default')),
                PopupMenuItem(value: ProductSort.priceLowToHigh, child: Text('Price: Low → High')),
                PopupMenuItem(value: ProductSort.priceHighToLow, child: Text('Price: High → Low')),
                PopupMenuItem(value: ProductSort.ratingHighToLow, child: Text('Rating: High → Low')),
              ],
              icon: const Icon(Icons.sort),
            ),
            CartBadgeButton(onTap: () => Navigator.pushNamed(context, AppRoutes.cart)),
          ] else ...[
            if (query.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
              ),
          ],
        ],
      ),
      body: isSearching ? const _SearchBody() : const _PaginationBody(),
    );
  }
}

class _SearchBody extends ConsumerWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRes = ref.watch(searchResultsProvider);
    final q = ref.watch(searchQueryProvider).trim();
    final sort = ref.watch(productSortProvider);

    if (q.isEmpty) return const Center(child: Text('Type to search products'));

    return asyncRes.when(
      loading: () => const ProductListSkeleton(),
      error: (e, _) => ProductsErrorView(
        error: e,
        onRetry: () => ref.invalidate(searchResultsProvider),
      ),
      data: (products) {
        final sorted = applySort(products, sort);
        if (sorted.isEmpty) return Center(child: Text('No results for "$q"'));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final p = sorted[i];
            return ProductCard(
              product: p,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
              ),
              onAddToCart: () async {
                await ref.read(cartProvider.notifier).add(p);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart: ${p.title}')),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _PaginationBody extends ConsumerWidget {
  const _PaginationBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsNotifierProvider);
    final sort = ref.watch(productSortProvider);
    final items = applySort(state.items, sort);

    if (state.isLoading) return const ProductListSkeleton();

    if (state.error != null && state.items.isEmpty) {
      return ProductsErrorView(
        error: state.error!,
        onRetry: () => ref.read(productsNotifierProvider.notifier).refresh(),
      );
    }

    if (state.items.isEmpty) return const _EmptyProducts();

    return Column(
      children: [
        const _CategoryChipsBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(productsNotifierProvider.notifier).refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                  ref.read(productsNotifierProvider.notifier).loadMore();
                }
                return false;
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  if (i < items.length) {
                    final p = items[i];
                    return ProductCard(
                      product: p,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
                      ),
                      onAddToCart: () async {
                        await ref.read(cartProvider.notifier).add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart: ${p.title}')),
                        );
                      },
                    );
                  }

                  if (state.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!state.hasMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Center(child: Text('No more products')),
                    );
                  }

                  return const SizedBox(height: 40);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChipsBar extends ConsumerWidget {
  const _CategoryChipsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCats = ref.watch(categoriesProvider);
    final state = ref.watch(productsNotifierProvider);
    final selected = state.category;

    return asyncCats.when(
      loading: () => const SizedBox(height: 52, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => const SizedBox(height: 52, child: Center(child: Text('Failed to load categories'))),
      data: (cats) {
        return SizedBox(
          height: 52,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('All'),
                selected: selected == null,
                onSelected: (_) => ref.read(productsNotifierProvider.notifier).setCategory(null),
              ),
              const SizedBox(width: 8),
              ...cats.map((c) {
                final isSel = selected == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_prettyCategory(c)),
                    selected: isSel,
                    onSelected: (_) => ref.read(productsNotifierProvider.notifier).setCategory(c),
                  ),
                );
              }),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  String _prettyCategory(String slug) {
    final words = slug.split('-');
    return words.map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text('No products yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text('Try again later.'),
          ],
        ),
      ),
    );
  }
}
