import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/cart_provider.dart';

class CheckoutSummaryPage extends ConsumerWidget {
  const CheckoutSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);

    const shipping = 10.0;
    final total = items.isEmpty ? 0.0 : subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: items.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...items.map((i) => Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(i.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${i.qty} × \$${i.product.price.toStringAsFixed(0)}'),
                        trailing: Text('\$${i.lineTotal.toStringAsFixed(2)}'),
                      ),
                    )),
                const SizedBox(height: 12),
                _RowLine(label: 'Subtotal', value: subtotal),
                const SizedBox(height: 6),
                const _RowLine(label: 'Shipping', value: shipping),
                const Divider(height: 28),
                _RowLine(label: 'Total', value: total, bold: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment integration later')),
                      );
                    },
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _RowLine extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;

  const _RowLine({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text('\$${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
