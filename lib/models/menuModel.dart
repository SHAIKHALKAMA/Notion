class MenuItem {
  final int id;
  final int customerId;
  final int partnerId;
  final int quantity;
  final String sizeType;
  final double regularOriginalPrice;
  final String name;
  final String description;
  final String image;
  final int cart_id;

  MenuItem({
    required this.id,
    required this.customerId,
    required this.partnerId,
    required this.quantity,
    required this.sizeType,
    required this.regularOriginalPrice,
    required this.name,
    required this.description,
    required this.image,
    required this.cart_id
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 1115,
      partnerId: json['partner_id'] ?? 0,
      quantity: json['cart_quantity'] ?? 0,
      sizeType: json['size_type'] ?? 'Multi-Size',
      regularOriginalPrice: json['regular_original_price'].toDouble() ?? 0.0,
      name: json['name'],
      description: json['description'],
      cart_id: json['cart_id'] ?? '',
      image: json['image'] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVLDP5s2j9u1x86fOb7kNKXanJeMn8zZ30ZQ&s");
  }

}