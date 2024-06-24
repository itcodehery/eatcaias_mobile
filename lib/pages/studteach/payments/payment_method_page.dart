import 'package:eat_caias/pages/studteach/payments/upi_interaction_page.dart';
import 'package:flutter/material.dart';

enum PaymentMethod { upi, cod, cc, dc }

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage(
      {Key? key, required this.shopName, required this.totalPrice})
      : super(key: key);

  final String shopName;
  final int totalPrice;

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod _method = PaymentMethod.upi;
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
              trailing: Radio(
                groupValue: _method,
                value: PaymentMethod.upi,
                onChanged: (value) {
                  setState(() {
                    _method = PaymentMethod.upi;
                  });
                },
              ),
            ),
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    const Text('Total: '),
                    Text(
                      "₹${widget.totalPrice}.00",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.amber.shade400,
                      Colors.orange.shade400,
                    ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade900.withOpacity(0.2),
                        spreadRadius: 0.2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      //gradient background
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {
                      if (_method == PaymentMethod.upi) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpiInteractionPage(
                                    shopName: widget.shopName,
                                    totalPrice: widget.totalPrice)));
                      } else {
                        Navigator.pop(context, 'Cash on Delivery');
                      }
                    },
                    child: const Text(
                      'Place Order',
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
