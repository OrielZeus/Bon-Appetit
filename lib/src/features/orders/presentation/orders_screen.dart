import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:bon_appetit/src/features/orders/data/orders_repository.dart';
import 'package:bon_appetit/src/features/orders/domain/order_preview.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.appState,
    required this.strings,
  });

  final AppState appState;
  final AppStrings strings;

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
    final canEdit = widget.appState.selectedUser.role != UserRole.customer;

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
          Text(widget.strings.t('orders'),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Pedidos locales y simulados desde Baker API.'),
          const SizedBox(height: 16),
          if (widget.appState.localOrders.isNotEmpty) ...[
            Text('Pedidos creados',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...widget.appState.localOrders.map(
              (order) => _LocalOrderCard(
                order: order,
                canEdit: canEdit,
                onUpdate: (status, payment) => widget.appState.updateOrder(
                  order,
                  status: status,
                  paymentStatus: payment,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text('Baker API', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
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
                    orders.map((order) => _ApiOrderCard(order: order)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LocalOrderCard extends StatelessWidget {
  const _LocalOrderCard({
    required this.order,
    required this.canEdit,
    required this.onUpdate,
  });

  final LocalOrder order;
  final bool canEdit;
  final void Function(String status, String payment) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(order.code,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Chip(label: Text(order.status)),
              ],
            ),
            Text('${order.customer} | ${order.paymentStatus}'),
            Text('Agenda: ${order.scheduledAt}'),
            Text('\$${order.total.toStringAsFixed(2)}'),
            if (canEdit) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () => onUpdate('Preparing', order.paymentStatus),
                    child: const Text('Preparar'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => onUpdate(order.status, 'Paid'),
                    child: const Text('Pago OK'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => onUpdate('Delivered', 'Paid'),
                    child: const Text('Entregar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ApiOrderCard extends StatelessWidget {
  const _ApiOrderCard({required this.order});

  final OrderPreview order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text(order.code),
        subtitle: Text('${order.customer} | ${order.status}'),
        trailing: Text('\$${order.total.toStringAsFixed(2)}'),
      ),
    );
  }
}
