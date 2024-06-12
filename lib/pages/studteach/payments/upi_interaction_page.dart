import 'package:flutter/material.dart';

class UpiInteractionPage extends StatefulWidget {
  const UpiInteractionPage(
      {Key? key,
      required this.shopName,
      required this.userName,
      required this.itemNames,
      required this.totalPrice,
      required this.quantity})
      : super(key: key);

  final String shopName;
  final String userName;
  final String itemNames;
  final int totalPrice;
  final int quantity;

  @override
  _UpiInteractionPageState createState() => _UpiInteractionPageState();
}

class _UpiInteractionPageState extends State<UpiInteractionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your UPI App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Column(
                children: [
                  const Text('Order Details'),
                  Text(widget.shopName),
                ],
              ),
              subtitle: Text(widget.itemNames.split(',').join('\n')),
            )
          ],
        ),
      ),
    );
  }
}
