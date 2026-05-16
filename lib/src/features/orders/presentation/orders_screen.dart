import 'package:bon_appetit/src/features/orders/data/orders_repository.dart';
import 'package:bon_appetit/src/features/orders/domain/order_preview.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _repository = OrdersRepository();
  late Future<List<OrderPreview>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _repository.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureOrders = _repository.fetchOrders();
        });
        await _futureOrders;
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Orders', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Draft and queued orders from the local Baker API.'),
          const SizedBox(height: 16),
          FutureBuilder<List<OrderPreview>>(
            future: _futureOrders,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              final orders = snapshot.data ?? const <OrderPreview>[];
              return Column(
                children:
                    orders.map((order) => _OrderCard(order: order)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderPreview order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.code,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(label: Text(order.status)),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.customer),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('${order.code} marked for review')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Review'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
