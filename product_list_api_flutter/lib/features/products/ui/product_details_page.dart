import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/cart_badge_button.dart';
import '../../cart/state/cart_provider.dart';
import '../data/api_product.dart';
import '../model/product.dart';
import '../state/product_details_provider.dart';

class ProductDetailsPage extends ConsumerWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetails = ref.watch(productDetailsProvider(product.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          CartBadgeButton(onTap: () => Navigator.pushNamed(context, AppRoutes.cart)),
        ],
      ),
      body: asyncDetails.when(
        loading: () => _DetailsLoading(product: product),
        error: (e, _) => _DetailsError(
          error: e,
          onRetry: () => ref.invalidate(productDetailsProvider(product.id)),
        ),
        data: (d) => _DetailsView(basic: product, details: d),
      ),
    );
  }
}

class _DetailsLoading extends StatelessWidget {
  final Product product;
  const _DetailsLoading({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        Hero(
          tag: 'product_${product.id}',
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(color: theme.colorScheme.surfaceContainerHighest),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _DetailsError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  const _DetailsError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: 10),
            Text('Failed to load details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsView extends ConsumerWidget {
  final Product basic;
  final ApiProduct details;

  const _DetailsView({required this.basic, required this.details});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        Hero(
          tag: 'product_${basic.id}',
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              basic.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(details.brand, style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(details.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '\$${details.price.toStringAsFixed(0)}',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 10),
                  if (details.discountPercentage > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('-${details.discountPercentage.toStringAsFixed(0)}%'),
                    ),
                  const Spacer(),
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 4),
                  Text(details.rating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip(text: _pretty(details.category)),
                  _Chip(text: 'Stock: ${details.stock}'),
                ],
              ),
              const SizedBox(height: 16),
              Text('About', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(details.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await ref.read(cartProvider.notifier).add(basic);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to cart: ${basic.title}')),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined),
                  label: const Text('Add to cart'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _pretty(String slug) {
    final words = slug.split('-');
    return words.map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text),
    );
  }
}
