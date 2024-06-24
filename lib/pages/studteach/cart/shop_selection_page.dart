import 'package:eat_caias/constants.dart';
import 'package:eat_caias/pages/studteach/cart/cart_controller.dart';
import 'package:eat_caias/pages/studteach/payments/payment_method_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopSelectionPage extends StatefulWidget {
  const ShopSelectionPage({Key? key, required this.shopNameList})
      : super(key: key);

  final Map<String, int> shopNameList;
  @override
  _ShopSelectionPageState createState() => _ShopSelectionPageState();
}

class _ShopSelectionPageState extends State<ShopSelectionPage> {
  String? username;
  Future<void> addToTicketDatabase() async {
    final controller = Get.find<CartController>();
    try {
      for (var item in controller.cartItems) {
        await supabase.from('ticket').insert({
          'item_name': item.title,
          'user_name': username!,
          'quantity': item.quantity,
          'total_price': item.totalPrice,
          'shop_name': item.shopName,
          'status': 'Pending',
        }).then((value) {
          Get.showSnackbar(normalGetSnackBar(
              "Added Tickets", "Check Tickets to see order status!"));
        });
      }

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } on PostgrestException catch (error) {
      debugPrint("Its a PostgrestException");
      Get.showSnackbar(GetSnackBar(
        message: error.message,
      ));
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (error) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _fetchUsername() async {
    try {
      final user = supabase.auth.currentUser!;
      final response = await supabase
          .from('studteach_user')
          .select()
          .eq('email', user.email!)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          username = (response['username'] ?? " ") as String;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Username is null')));
        }
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  void initState() {
    _fetchUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shop to Pay'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ListTile(
            title: const Text(
                "A strict no return or cancellation policy is implemented in all canteens.",
                style: TextStyle(
                  fontSize: 15,
                ),
                overflow: TextOverflow.fade),
            trailing: ElevatedButton(
                onPressed: () {}, child: const Text("Know More")),
          ),
        ),
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
                  // addToTicketDatabase();
                  Get.to(() => PaymentMethodPage(
                        shopName: widget.shopNameList.keys.elementAt(index),
                        totalPrice: widget.shopNameList.values.elementAt(index),
                      ));
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
