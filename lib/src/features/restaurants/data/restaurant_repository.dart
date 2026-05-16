import 'package:bon_appetit/src/core/network/api_client.dart';
import 'package:bon_appetit/src/features/restaurants/domain/restaurant.dart';

class RestaurantRepository {
  RestaurantRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await _apiClient.getJson('/restaurants');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException('Restaurants response is missing data list.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(Restaurant.fromJson)
        .toList();
  }
}
