import 'package:Eat.Caias/provider/cart_provider.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> cartItems = [];
  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() {
    //fetch cart items
    cartItems = CartProvider().cartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'my cart',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: cartItems.isNotEmpty
          ? ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Item'),
                  leading: Icon(Icons.fastfood),
                  trailing: Text('₹ 100'),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Checkout'),
      ),
    );
  }
}
