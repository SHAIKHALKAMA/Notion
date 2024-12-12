import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/menuModel.dart';

Future<List<MenuItem>> fetchMenuItems() async {
  const String apiUrl =
      'https://thealaddin.in/mmApi/api/show/menu-list?customer_id=1115&hotel_id=15';
  try {
    final response = await http.get(Uri.parse(apiUrl),);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<MenuItem> menuItems = [];
      for (var item in data['data']) {
        menuItems.add(MenuItem.fromJson(item));
      }
      return menuItems;
    } else {
      print('API call failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load menu items');
    }
  } catch (e) {
    print('Error fetching data: $e');
    throw Exception('Error fetching data: $e');
  }
}


Future<Map<String, dynamic>?> addToCart(MenuItem menuItem, BuildContext context) async {
  const String apiUrl = 'https://thealaddin.in/mmApi/api/add/cart';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'menu_id': menuItem.id.toString(),
        'customer_id': menuItem.customerId.toString(),
        'partner_id': menuItem.partnerId.toString(),
        'quantity': menuItem.quantity.toString(),
        'size': menuItem.sizeType,
        'amount': menuItem.regularOriginalPrice.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('cart')) {
        return data;
      } else {
        debugPrint('Unexpected response format: $data');
        return null;
      }
    } else {
      debugPrint('API error: ${response.body}');
      return null;
    }
  } catch (e) {
    debugPrint('Error adding to cart: $e');
    return null;
  }
}



