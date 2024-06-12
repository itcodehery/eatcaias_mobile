import 'package:Eat.Caias/pages/studteach/payments/upi_interaction_page.dart';
import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
                title: const Text('UPI'),
                leading: const Icon(Icons.payment),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const UpiInteractionPage(
                            shopName: 'shopName',
                            userName: 'userName',
                            itemNames: 'Chicken Roll,Chicken Biryani,Coke',
                            totalPrice: 0,
                            quantity: 0,
                          )));
                }),
            ListTile(
                enabled: false,
                subtitle: const Text("We're working on it!"),
                title: const Text('Cash on Delivery'),
                leading: const Icon(Icons.money),
                onTap: () {
                  Navigator.pop(context, 'Cash on Delivery');
                }),
          ],
        ),
      ),
    );
  }
}
