import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/config/app_config.dart';
import 'package:bon_appetit/src/features/catalog/models/catalog_item.dart';
import 'package:bon_appetit/src/features/dashboard/models/feature_module.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/catalog_item_card.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/hero_panel.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/module_card.dart';
import 'package:bon_appetit/src/features/orders/data/orders_repository.dart';
import 'package:bon_appetit/src/features/orders/domain/order_preview.dart';
import 'package:bon_appetit/src/features/restaurants/data/restaurant_repository.dart';
import 'package:bon_appetit/src/features/restaurants/domain/restaurant.dart';
import 'package:bon_appetit/src/features/server_status/server_status_card.dart';
import 'package:bon_appetit/src/features/tracker/domain/tracker_event.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onOpenSection});

  final ValueChanged<int> onOpenSection;

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

  static const _catalogItems = <CatalogItem>[
    CatalogItem(
      name: 'Stone Oven Pizza',
      category: 'Restaurant special',
      price: 12.90,
      assetPath: AppAssets.pizza,
      badge: 'Hot',
    ),
    CatalogItem(
      name: 'Beef Burger',
      category: 'Delivery favorite',
      price: 9.50,
      assetPath: AppAssets.burger,
      badge: 'Top',
    ),
    CatalogItem(
      name: 'Cup Cake Box',
      category: 'Bakery',
      price: 7.20,
      assetPath: AppAssets.cupcake,
      badge: 'Sweet',
    ),
    CatalogItem(
      name: 'Dessert Plate',
      category: 'Meal Monkey import',
      price: 6.80,
      assetPath: AppAssets.dessertOne,
      badge: 'Legacy',
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
            HeroPanel(
              onExploreMenu: () => onOpenSection(1),
              onTrackOrder: () => onOpenSection(3),
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
                    return ModuleCard(
                      module: _modules[index],
                      onTap: () => onOpenSection(index == 0 ? 1 : index),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Featured Menu',
              child: SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _catalogItems.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 12,
                  ),
                  itemBuilder: (context, index) {
                    return CatalogItemCard(item: _catalogItems[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Restaurant Seeds',
              action: TextButton.icon(
                onPressed: () => onOpenSection(1),
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('Open'),
              ),
              child: _RestaurantPreview(
                repository: RestaurantRepository(),
                assetResolver: _restaurantAsset,
              ),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Order Seeds',
              action: TextButton.icon(
                onPressed: () => onOpenSection(2),
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('Open'),
              ),
              child: _OrderPreviewList(repository: OrdersRepository()),
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

  String _restaurantAsset(String name) {
    return switch (name) {
      'Bon Bakery' => AppAssets.restaurantOne,
      'Meal Monkey Legacy' => AppAssets.restaurantTwo,
      _ => AppAssets.restaurantThree,
    };
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _RestaurantPreview extends StatelessWidget {
  const _RestaurantPreview({
    required this.repository,
    required this.assetResolver,
  });

  final RestaurantRepository repository;
  final String Function(String name) assetResolver;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
      future: repository.fetchRestaurants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingRows(label: 'Loading restaurants...');
        }

        if (snapshot.hasError) {
          return _ErrorText(message: snapshot.error.toString());
        }

        final restaurants = snapshot.data ?? const <Restaurant>[];
        return Column(
          children: restaurants.take(3).map((restaurant) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  assetResolver(restaurant.name),
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(restaurant.name),
              subtitle: Text(restaurant.category),
              trailing: Text(
                '${restaurant.rating} | ${restaurant.deliveryMinutes}m',
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OrderPreviewList extends StatelessWidget {
  const _OrderPreviewList({required this.repository});

  final OrdersRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderPreview>>(
      future: repository.fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingRows(label: 'Loading orders...');
        }

        if (snapshot.hasError) {
          return _ErrorText(message: snapshot.error.toString());
        }

        final orders = snapshot.data ?? const <OrderPreview>[];
        return Column(
          children: orders.take(3).map((order) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text(order.code),
              subtitle: Text('${order.customer} | ${order.status}'),
              trailing: Text('\$${order.total.toStringAsFixed(2)}'),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LoadingRows extends StatelessWidget {
  const _LoadingRows({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      message,
      style: TextStyle(color: colors.error),
    );
  }
}
