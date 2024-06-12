import 'package:flutter/material.dart';

class ShopSelectionPage extends StatefulWidget {
  const ShopSelectionPage({Key? key, required this.shopNameList})
      : super(key: key);

  final Map<String, int> shopNameList;
  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shop'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: const Text('Shop Name'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/cart');
            },
          );
        },
      ),
    );
  }
}
