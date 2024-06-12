import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/cart/cart_controller.dart';
import 'package:Eat.Caias/pages/studteach/cart/shop_selection_page.dart';
import 'package:Eat.Caias/pages/studteach/tickets/ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final dynamic cartController;

  //shopname and price of the shop's items
  late Map<String, int> shopNameList = {};

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController());
    for (var element in cartController.cartItems) {
      if (!shopNameList.containsKey(element.shopName)) {
        shopNameList[element.shopName] = 0;
      }
    }
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
      body: GetX<CartController>(
          init: CartController(),
          builder: (controller) {
            return controller.cartItems.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      shopNameList[controller.cartItems
                          .elementAt(index)
                          .shopName] = shopNameList[
                              controller.cartItems.elementAt(index).shopName]! +
                          controller.cartItems.elementAt(index).price;
                      return CartListTile(
                        title: controller.cartItems.elementAt(index).title,
                        price: controller.cartItems.elementAt(index).totalPrice,
                        quantity:
                            controller.cartItems.elementAt(index).quantity,
                        shopName:
                            controller.cartItems.elementAt(index).shopName,
                      );
                    },
                  )
                : const Center(
                    child: Text('No items in cart! Add some items!'));
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (cartController.totalCartPrice != 0) {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text('Order Confirmation',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          const ListTile(
                              title: Text(
                                  'Are you sure you want to place this order?')),
                          const Divider(),
                          ListTile(
                            title: const Text('Total Price:'),
                            trailing: Text(
                              '₹${cartController.totalCartPrice}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShopSelectionPage(
                                        shopNameList: shopNameList,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                normalSnackBar('Add some items to cart to place order!'));
          }
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: Obx(() => Text(' ₹${cartController.totalCartPrice}')),
      ),
    );
  }
}

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.shopName,
  });

  final String title;
  final int quantity;
  final int price;
  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Card(
        elevation: 0,
        color: Colors.amber.shade100.withAlpha(50),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('x $quantity  |  from $shopName'),
          leading: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.white,
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.brown)),
            onPressed: () {
              Get.find<CartController>().removeFromCart(title);
              Get.find<TicketController>();
              showCartToast('$title (x$quantity) removed from Cart', context);
            },
          ),
          trailing: Text(
            '₹ $price',
            style: TextStyle(
              color: Colors.brown.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
