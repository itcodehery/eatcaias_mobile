import 'package:Eat.Caias/pages/studteach/payments/payment_method_page.dart';
import 'package:flutter/material.dart';

class ShopSelectionPage extends StatefulWidget {
  const ShopSelectionPage({Key? key, required this.shopNameList})
      : super(key: key);

  final Map<String, int> shopNameList;
  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  Future<void> addToTicketDatabase() async {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shop to Pay'),
      ),
      body: ListView.builder(
        itemCount: widget.shopNameList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.amber.shade400,
                  Colors.orange.shade400,
                ]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                tileColor: Colors.transparent,
                title: Text(widget.shopNameList.keys.elementAt(index)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("₹${widget.shopNameList.values.elementAt(index)}",
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right)
                  ],
                ),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentMethodPage(
                  //       shopName: widget.shopNameList.keys.elementAt(index),
                  //       totalPrice: widget.shopNameList.values.elementAt(index),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Checkout: '),
            Text(
              "₹${widget.shopNameList.values.fold(0, (previousValue, element) {
                return previousValue + element;
              })}.00",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
