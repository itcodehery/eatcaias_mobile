import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/cart/cart_controller.dart';
import 'package:Eat.Caias/pages/studteach/payments/payment_method_page.dart';
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
          'total_price': item.price * item.quantity,
          'shop_name': item.shopName,
          'status': 'Pending',
        });
      }
      Get.showSnackbar(normalGetSnackBar(
          "Added Tickets", "Check Tickets to see order status!"));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on PostgrestException catch (error) {
      debugPrint("Its a PostgrestException");
      Get.showSnackbar(GetSnackBar(
        message: error.message,
      ));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (error) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Username is null')));
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
                  addToTicketDatabase();
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
