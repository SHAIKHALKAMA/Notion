import 'package:flutter/material.dart';
import 'package:notion_task/screens/cart_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:notion_task/models/menuModel.dart'; // Assuming your MenuItem model is here
import '../api_service/menus.dart'; // Assuming API functions are here

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<MenuItem> menuList = [];
  bool isLoading = true;

  Set<int> addedItems = {};
  @override
  void initState() {
    super.initState();
    fetchMenuItemsFromApi();
  }

  Future<void> fetchMenuItemsFromApi() async {
    try {
      final fetchedMenuItems = await fetchMenuItems();
      setState(() {
        menuList = fetchedMenuItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch menu items.')));
    }
  }

  Future<void> AddToCart(MenuItem menuItem) async {
    final response = await addToCart(menuItem, context);

    if (response != null && response.containsKey('cart')) {
      setState(() {
        addedItems.add(menuItem.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item Added to Cart'),
          action: SnackBarAction(
            label: 'Go to Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItem: response['cart']),
                ),
              );
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item to cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: isLoading
          ? ListView.builder(
              itemCount: 5, // Placeholder item count for shimmer effect
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      title: Container(
                        width: 150,
                        height: 10,
                        color: Colors.white,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 100,
                            height: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menuItem = menuList[index];
                final isAdded = addedItems.contains(menuItem.id);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.yellow,
                      )
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.network(
                      menuItem.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVLDP5s2j9u1x86fOb7kNKXanJeMn8zZ30ZQ&s'); // Placeholder in case of error
                      },
                    ),
                    title: Text(menuItem.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(menuItem.description),
                        const SizedBox(height: 5),
                        Text('Price: ₹${menuItem.regularOriginalPrice}'),
                        const SizedBox(height: 5),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: isAdded
                          ? null // Disable the button if the item is already added
                          : () => AddToCart(menuItem),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: isAdded ? Colors.yellow : Colors.yellow),
                          borderRadius: BorderRadius.circular(
                              12.0), // Adjust the radius as needed
                        ),
                        backgroundColor:
                            isAdded ? Colors.white: Colors.yellow,
                      ),
                      child: Text(isAdded ? 'Added' : 'Add to Cart',style: const TextStyle(
                        color: Colors.black
                      ),),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
