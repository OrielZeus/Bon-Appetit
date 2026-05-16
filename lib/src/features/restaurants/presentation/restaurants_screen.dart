import 'package:bon_appetit/src/core/assets/app_assets.dart';
import 'package:bon_appetit/src/features/catalog/models/catalog_item.dart';
import 'package:bon_appetit/src/features/dashboard/widgets/catalog_item_card.dart';
import 'package:bon_appetit/src/features/restaurants/data/restaurant_repository.dart';
import 'package:bon_appetit/src/features/restaurants/domain/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final _repository = RestaurantRepository();

  static const _menu = <CatalogItem>[
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
      category: 'Legacy dessert',
      price: 6.80,
      assetPath: AppAssets.dessertTwo,
      badge: 'Meal',
    ),
  ];

  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = _repository.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
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
          Text('Restaurants & Bakery',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
              'Live restaurant data from the Baker API plus migrated menu examples.'),
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
              return Column(
                children: restaurants
                    .map(
                        (restaurant) => _RestaurantCard(restaurant: restaurant))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 18),
          Text('Menu examples', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _menu.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  CatalogItemCard(item: _menu[index]),
            ),
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
      margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(restaurant.category),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${restaurant.name} selected')),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined),
                  label: const Text('Order'),
                ),
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
