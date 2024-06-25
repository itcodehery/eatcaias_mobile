import 'package:eat_caias/constants.dart';
import 'package:eat_caias/models/cart_item.dart';
import 'package:eat_caias/models/menu_item.dart';
import 'package:eat_caias/pages/studteach/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  final MenuItem item;

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String? itemImageURL;
  int quantity = 0;

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
              : Container(),
          Padding(
            padding: cardPadding,
            child: Card(
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
                  const Divider(),
                  ListTile(
                    title: Text(
                      "₹${currentItem.price}",
                      style: headerTextStyle,
                    ),
                    subtitle: Text("from ${currentItem.shopName}"),
                  ),
                  const Divider(),
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
                                    quantity = quantity > 0 ? quantity - 1 : 0;
                                  });
                                },
                              ),
                              Text(quantity.toString(), style: headerTextStyle),
                              IconButton(
                                style: iconButtonStyle,
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    quantity = quantity + 1;
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
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (quantity == 0) {
            Get.showSnackbar(normalGetSnackBar(
                "Oops!", "The quantity you've chosen is nil."));
          } else {
            Get.find<CartController>().addToCart(currentItem.itemName, quantity,
                (currentItem.price * quantity), currentItem.shopName);
            Get.showSnackbar(normalGetSnackBar(
                "Success!", "Added $quantity items to cart."));
            Navigator.of(context).pop();
          }
        },
        label: Text(quantity == 0 ? "Add to Cart" : "Add (x$quantity) to Cart"),
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
