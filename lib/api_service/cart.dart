// cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  static const String baseUrl = 'https://thealaddin.in';

  Future<Map<String, dynamic>?> fetchTotalDetails(String customerId) async {
    const String apiUrl = '$baseUrl/mmApi/api/cart/total';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'customer_id': customerId}),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['data'];
      } else {
        throw Exception('Failed to fetch total details');
      }
    } catch (e) {
      throw Exception('Error fetching total details: $e');
    }
  }

  Future<void> updateQuantity(int cartId, String status) async {
    const String apiUrl = '$baseUrl/mmApi/api/add-remove/quantity/cart';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'cart_id': cartId.toString(),
          'status': status,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update quantity');
      }
    } catch (e) {
      throw Exception('Error updating quantity: $e');
    }
  }
}
