import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
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
  const DashboardScreen({
    super.key,
    required this.appState,
    required this.strings,
    required this.onOpenSection,
  });

  final AppState appState;
  final AppStrings strings;
  final ValueChanged<int> onOpenSection;

  List<FeatureModule> get _modules => [
        FeatureModule(
          title: strings.t('menu'),
          description:
              'Restaurant, bakery, menu, catalog, offer and rating flows.',
          icon: Icons.restaurant_menu_outlined,
          status: 'Migrating UI',
        ),
        FeatureModule(
          title: strings.t('orders'),
          description: 'Cart, checkout, payment intent and local API handoff.',
          icon: Icons.receipt_long_outlined,
          status: 'API planned',
        ),
        FeatureModule(
          title: strings.t('track'),
          description: 'Order timeline, address changes and courier state.',
          icon: Icons.delivery_dining_outlined,
          status: 'Model ready',
        ),
        const FeatureModule(
          title: 'Documentation',
          description:
              'Unification notes, review checklist and release evidence.',
          icon: Icons.article_outlined,
          status: 'README seeded',
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
    final modules = _modules;
    return ListView(
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
              itemCount: modules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: columns == 4 ? 220 : 240,
              ),
              itemBuilder: (context, index) {
                return ModuleCard(
                  module: modules[index],
                  onTap: () => onOpenSection(index == 0 ? 1 : index),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        _Section(
          title: strings.t('menu'),
          child: SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: appState.products.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: 12,
              ),
              itemBuilder: (context, index) {
                final product = appState.products[index];
                return CatalogItemCard(
                  item: CatalogItem(
                    name: product.name,
                    category: product.category,
                    price: product.price,
                    assetPath: product.assetPath,
                    badge: '${product.preparationMinutes}m',
                  ),
                  actionLabel: strings.t('addToCart'),
                  onAdd: () => appState.addToCart(product),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: 'Restaurantes',
          action: TextButton.icon(
            onPressed: () => onOpenSection(1),
            icon: const Icon(Icons.open_in_new_outlined),
            label: Text(strings.t('menu')),
          ),
          child: _RestaurantPreview(
            repository: RestaurantRepository(),
            assetResolver: _restaurantAsset,
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: strings.t('orders'),
          action: TextButton.icon(
            onPressed: () => onOpenSection(2),
            icon: const Icon(Icons.open_in_new_outlined),
            label: Text(strings.t('orders')),
          ),
          child: _OrderPreviewList(repository: OrdersRepository()),
        ),
        const SizedBox(height: 12),
        _Section(
          title: strings.t('track'),
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
