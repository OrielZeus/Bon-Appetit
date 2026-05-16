import 'package:bon_appetit/src/core/network/api_client.dart';
import 'package:bon_appetit/src/features/orders/domain/order_preview.dart';

class OrdersRepository {
  OrdersRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<OrderPreview>> fetchOrders() async {
    final response = await _apiClient.getJson('/orders');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException('Orders response is missing data list.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(OrderPreview.fromJson)
        .toList();
  }
}
