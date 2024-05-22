import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
      body: const Center(
        child: Text('My Cart'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              content: const Text('Wanna buy nothing?'),
              actions: [
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                    },
                    child: const Text('Nah'))
              ]));
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Checkout'),
      ),
    );
  }
}
