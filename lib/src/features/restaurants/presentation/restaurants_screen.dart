import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/core/localization/app_strings.dart';
import 'package:bon_appetit/src/core/state/app_state.dart';
import 'package:bon_appetit/src/features/catalog/models/catalog_item.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/catalog_item_card.dart';
import 'package:bon_appetit/src/features/restaurants/data/restaurant_repository.dart';
import 'package:bon_appetit/src/features/restaurants/domain/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({
    super.key,
    required this.appState,
    required this.strings,
  });

  final AppState appState;
  final AppStrings strings;

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final _repository = RestaurantRepository();
  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = _repository.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 820;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureRestaurants = _repository.fetchRestaurants();
        });
        await _futureRestaurants;
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.strings.t('menu'),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Restaurantes en vivo y menú configurable.'),
          const SizedBox(height: 16),
          FutureBuilder<List<Restaurant>>(
            future: _futureRestaurants,
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
                return _ErrorPanel(message: snapshot.error.toString());
              }

              final restaurants = snapshot.data ?? const <Restaurant>[];
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: restaurants
                    .map(
                      (restaurant) => SizedBox(
                        width: isWide ? 360 : double.infinity,
                        child: _RestaurantCard(restaurant: restaurant),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 18),
          Text('Productos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.appState.products.map((product) {
              return SizedBox(
                height: 270,
                child: CatalogItemCard(
                  item: CatalogItem(
                    name: product.name,
                    category: product.category,
                    price: product.price,
                    assetPath: product.assetPath,
                    badge: '${product.preparationMinutes}m',
                  ),
                  actionLabel: widget.strings.t('addToCart'),
                  onAdd: () {
                    widget.appState.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} agregado')),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Image.asset(
              restaurant.name == 'Bon Bakery'
                  ? AppAssets.restaurantOne
                  : AppAssets.restaurantTwo,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant.name,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(restaurant.category),
                const SizedBox(height: 8),
                Text('${restaurant.rating} | ${restaurant.deliveryMinutes}m'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message, style: TextStyle(color: colors.error)),
      ),
    );
  }
}
