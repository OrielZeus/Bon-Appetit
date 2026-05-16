import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/features/dashboard/models/feature_module.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/module_card.dart';
import 'package:bon_appetit/src/features/orders/domain/order_preview.dart';
import 'package:bon_appetit/src/features/restaurants/domain/restaurant.dart';
import 'package:bon_appetit/src/features/server_status/server_status_card.dart';
import 'package:bon_appetit/src/features/tracker/domain/tracker_event.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _modules = <FeatureModule>[
    FeatureModule(
      title: 'Restaurants',
      description: 'Restaurant, bakery, menu, catalog, offer and rating flows.',
      icon: Icons.restaurant_menu_outlined,
      status: 'Migrating UI',
    ),
    FeatureModule(
      title: 'Orders',
      description: 'Cart, checkout, payment intent and local API handoff.',
      icon: Icons.receipt_long_outlined,
      status: 'API planned',
    ),
    FeatureModule(
      title: 'Delivery tracker',
      description: 'Order timeline, address changes and courier state.',
      icon: Icons.delivery_dining_outlined,
      status: 'Model ready',
    ),
    FeatureModule(
      title: 'Documentation',
      description: 'Unification notes, review checklist and release evidence.',
      icon: Icons.article_outlined,
      status: 'README seeded',
    ),
  ];

  static const _restaurants = <Restaurant>[
    Restaurant(
      name: 'Bon Bakery',
      category: 'Bakery and desserts',
      rating: 4.8,
      deliveryMinutes: 25,
    ),
    Restaurant(
      name: 'Meal Monkey Legacy',
      category: 'Food delivery reference',
      rating: 4.6,
      deliveryMinutes: 32,
    ),
  ];

  static const _orders = <OrderPreview>[
    OrderPreview(
      code: 'BA-0001',
      customer: 'Internal QA',
      total: 42.50,
      status: 'Draft',
    ),
    OrderPreview(
      code: 'BA-0002',
      customer: 'Kitchen test',
      total: 18.90,
      status: 'Queued',
    ),
  ];

  static const _timeline = <TrackerEvent>[
    TrackerEvent(
      title: 'Project created',
      detail: 'Flutter base generated in C:\\Projects.',
      isDone: true,
    ),
    TrackerEvent(
      title: 'Legacy inventory mapped',
      detail: 'Delivery, restaurant, checkout and assets identified.',
      isDone: true,
    ),
    TrackerEvent(
      title: 'Docker server',
      detail: 'Local API and Postgres compose are next execution targets.',
      isDone: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: [
          IconButton(
            tooltip: 'Source projects',
            onPressed: () => _showSources(context),
            icon: const Icon(Icons.source_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Unified restaurant, bakery and delivery workspace',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'A clean Flutter shell for consolidating the old delivery projects while keeping the local Docker API separate and traceable.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            const ServerStatusCard(),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 760 ? 4 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _modules.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: columns == 4 ? 220 : 240,
                  ),
                  itemBuilder: (context, index) {
                    return ModuleCard(module: _modules[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Restaurant Seeds',
              child: Column(
                children: _restaurants
                    .map(
                      (restaurant) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.storefront_outlined),
                        title: Text(restaurant.name),
                        subtitle: Text(restaurant.category),
                        trailing: Text(
                          '${restaurant.rating} | ${restaurant.deliveryMinutes}m',
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Order Seeds',
              child: Column(
                children: _orders
                    .map(
                      (order) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text(order.code),
                        subtitle: Text(order.customer),
                        trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Tracker Plan',
              child: Column(
                children: _timeline
                    .map(
                      (event) => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: event.isDone,
                        onChanged: null,
                        title: Text(event.title),
                        subtitle: Text(event.detail),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSources(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Source projects'),
        content: Text(AppConfig.sourceProjects.join('\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
