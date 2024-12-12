import 'package:flutter/material.dart';
import 'package:notion_task/api_service/cart.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic> cartItem;

  const CartPage({super.key, required this.cartItem});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? totalDetails;
  late int _quantity;
  final CartService _cartService = CartService(); // API service instance

  @override
  void initState() {
    super.initState();
    _quantity = int.tryParse(widget.cartItem['quantity']?.toString() ?? '1') ?? 1;
    _fetchTotalDetails();
  }

  Future<void> _fetchTotalDetails() async {
    try {
      final details = await _cartService.fetchTotalDetails('1115'); // Replace with actual customer_id
      setState(() {
        totalDetails = details;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateQuantity(int cartId, String action) async {
    try {
      await _cartService.updateQuantity(cartId, action == 'increase' ? 'Add' : 'Remove');
      setState(() {
        if (action == 'increase') {
          _quantity++;
        } else if (action == 'decrease' && _quantity > 1) {
          _quantity--;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.cartItem['menu_image'] != null
        ? '${CartService.baseUrl}${widget.cartItem['menu_image']}'
        : 'https://via.placeholder.com/150';

    final double price = double.tryParse(widget.cartItem['menu_price']?.toString() ?? '0.0') ?? 0.0;
    final double subtotal = _quantity * price;
    final double shippingPrice = totalDetails?['shipping_price']?.toDouble() ?? 0.0;
    final double totalBill = subtotal + shippingPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://via.placeholder.com/150',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cartItem['menu_name'] ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Price: ₹${widget.cartItem['menu_price'] ?? '0'}'),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 212, 150, 15)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _updateQuantity(widget.cartItem['id'], 'decrease');
                        },
                      ),
                      Text('$_quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _updateQuantity(widget.cartItem['id'], 'increase');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            totalDetails != null
                ? Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("$_quantity X ${widget.cartItem['menu_name']} "),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sub Total: '),
                            Text("₹$subtotal"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Charges:'),
                            Text("₹${totalDetails!['shipping_price'] ?? 0}"),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Bill'),
                            Text(
                              "₹$totalBill",
                              style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: const Text("No Coupon Available"),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: const Center(child: Text("Place Order")),
            ),
          ],
        ),
      ),
    );
  }
}
