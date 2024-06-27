import 'package:eat_caias/constants.dart';
import 'package:eat_caias/models/cart_item.dart';
import 'package:eat_caias/models/menu_item.dart';
import 'package:eat_caias/pages/studteach/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage(
      {Key? key, required this.item, required this.shopIsOpen})
      : super(key: key);

  final MenuItem item;
  final bool shopIsOpen;

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String? itemImageURL;
  int quantity = 1;

  Future<void> getImageURL() async {
    Future.delayed(Durations.extralong4).then((value) {
      setState(() {
        itemImageURL = widget.item.imageUrl;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    MenuItem currentItem = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
      ),
      body: Column(
        children: [
          itemImageURL != null
              ? Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(itemImageURL!),
                          fit: BoxFit.cover)),
                )
              : Shimmer(
                  color: Colors.amber,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
          Padding(
            padding: cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentItem.itemName,
                          style: headerTextStyle,
                        ),
                        isVegTag(currentItem.isVeg)
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text(currentItem.description),
                ),
                // const Divider(),
                ListTile(
                  title: Text(
                    "₹${currentItem.price}",
                    style: headerTextStyle,
                  ),
                  subtitle: Text("from ${currentItem.shopName}"),
                ),
                // const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(50),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              style: iconButtonStyle,
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  quantity = quantity > 1 ? quantity - 1 : 1;
                                });
                              },
                            ),
                            Text(quantity.toString(), style: headerTextStyle),
                            IconButton(
                              style: iconButtonStyle,
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < 10) {
                                    quantity++;
                                  } else {
                                    Get.showSnackbar(normalGetSnackBar(
                                        "Sorry!", "Max quantity is 10."));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      isStockedTag(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: widget.shopIsOpen
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.amber.shade400,
                        Colors.orange.shade400,
                      ]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          elevation: WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ))),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              //confirm
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: Text(
                                    "Add $quantity ${currentItem.itemName}(s) to cart?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.find<CartController>().addToCart(
                                          currentItem.itemName,
                                          quantity,
                                          (currentItem.price * quantity),
                                          currentItem.shopName);
                                      Get.showSnackbar(normalGetSnackBar(
                                          "Success!",
                                          "Added $quantity items to cart."));
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Confirm"),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined),
                          const SizedBox(width: 10),
                          Text(quantity == 0
                              ? "Add to Cart"
                              : "Add (x$quantity) to Cart"),
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.grey.shade400,
                        Colors.grey.shade600,
                      ]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          elevation: WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ))),
                      onPressed: () {
                        Get.showSnackbar(
                            normalGetSnackBar("Sorry!", "Shop is closed."));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Shop Closed",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }
}
