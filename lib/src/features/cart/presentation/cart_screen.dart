import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.appState, required this.strings});

  final AppState appState;
  final AppStrings strings;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 2));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(widget.strings.t('cart'),
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (widget.appState.cart.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('El carrito está vacío.'),
            ),
          )
        else ...[
          ...widget.appState.cart.map(
            (item) => Card(
              child: ListTile(
                leading: Image.asset(item.product.assetPath, width: 54),
                title: Text(item.product.name),
                subtitle: Text(
                  '${item.quantity} x \$${item.product.price.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  onPressed: () =>
                      widget.appState.removeFromCart(item.product.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Total: \$${widget.appState.cartTotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text('${widget.strings.t('schedule')}: $_scheduledAt'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _scheduledAt =
                              DateTime.now().add(const Duration(hours: 2));
                        }),
                        icon: const Icon(Icons.today_outlined),
                        label: const Text('Hoy + 2h'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _scheduledAt =
                              DateTime.now().add(const Duration(days: 14));
                        }),
                        icon: const Icon(Icons.event_outlined),
                        label: const Text('2 semanas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      widget.appState.createOrder(_scheduledAt);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pedido creado')),
                      );
                    },
                    icon: const Icon(Icons.check_outlined),
                    label: Text(widget.strings.t('createOrder')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
