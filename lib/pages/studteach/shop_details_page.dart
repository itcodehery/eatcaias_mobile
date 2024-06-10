import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopDetailsPage extends StatefulWidget {
  const ShopDetailsPage({
    Key? key,
    required this.shopName,
  }) : super(key: key);

  final String shopName;

  @override
  _ShopDetailsPageState createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];

  //initState
  @override
  void initState() {
    super.initState();
    _fetchShops();
    _fetchShopItems();
  }

  Future<void> _fetchShopItems() async {
    try {
      final shopItems = await supabase
          .from('menu_item')
          .select()
          .eq('shop_name', widget.shopName);
      if (shopItems.isNotEmpty) {
        setState(() {
          _shopItems = shopItems;
          //sort by ascending order
          _shopItems.sort(
              (a, b) => a["item_name"].toString().compareTo(b["item_name"]));
        });
      } else {
        return;
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
          content: const Text('Unexpected error occurred while fetching items'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Future<void> _fetchShops() async {
    try {
      final data = await supabase
          .from('canteen_shop')
          .select()
          .eq('shop_name', widget.shopName)
          .single();

      if (data.isNotEmpty) {
        setState(() {
          _shopDetails = data;
        });
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
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.amber,
                  Colors.orange.shade500,
                ]),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.shopName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _shopDetails['description'] != null
                            ? Text(_shopDetails['description'])
                            : const Text("Loading canteen details..."),
                        const SizedBox(height: 10),
                        _shopDetails['is_open'] != null
                            ? isOpenTag(_shopDetails['is_open']!)
                            : const SizedBox(),
                      ]),
                ),
              )),
          _shopItems.isNotEmpty
              ? ListTile(
                  title: const Text('Items available'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                )
              : const SizedBox(),
          _shopItems.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _shopItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: _shopItems.length,
                          itemBuilder: (context, index) {
                            return getCustomListTile(index);
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No items available"),
                  ),
                ),
        ],
      ),
    );
  }

  Widget getCustomListTile(int index) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          )),
      child: ListTile(
        enabled: _shopItems[index]["is_inStock"] as bool,
        tileColor: Colors.white,
        title: Text(_shopItems[index]["item_name"]! as String,
            overflow: TextOverflow.ellipsis),
        subtitle: Text(
          _shopItems[index]["is_inStock"] as bool
              ? _shopItems[index]["description"]! as String
              : "OUT OF STOCK",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          children: [
            isVegTag(_shopItems[index]["is_veg"] as bool),
          ],
        ),
        onTap: () {
          var itemCount = 0.obs;
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: dialogPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: const ButtonStyle(
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero)),
                          ),
                          _shopItems[index]["image_url"] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(_shopItems[index]
                                            ["image_url"] as String),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          // const SizedBox(height: 10),
                          Text(_shopItems[index]["item_name"]! as String,
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                              overflow: TextOverflow.ellipsis),
                          isVegTag(_shopItems[index]["is_veg"] as bool),
                          Text(_shopItems[index]["description"]! as String),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${_shopItems[index]["price"] as int}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (itemCount > 0) {
                                            setState(() {
                                              itemCount = RxInt(0);
                                            });
                                            Get.find<CartController>()
                                                .removeFromCart(
                                                    _shopItems[index]
                                                            ["item_name"]
                                                        as String);
                                            showCartToast(
                                              "${_shopItems[index]["item_name"]! as String} quantity is 0",
                                              context,
                                            );
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.close)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          itemCount++;
                                        });

                                        showCartToast(
                                            "${_shopItems[index]["item_name"]! as String} (x$itemCount)",
                                            context);
                                      },
                                      icon: const Icon(Icons.add)),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),

                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.orange.shade200),
                                minimumSize: const MaterialStatePropertyAll(
                                    Size(double.infinity, 40))),
                            onPressed: () {
                              if (itemCount.value != 0) {
                                Get.find<CartController>().addToCart(
                                    _shopItems[index]["item_name"] as String,
                                    itemCount.value,
                                    _shopItems[index]["price"] as int,
                                    widget.shopName);
                                showCartToast(
                                    '${_shopItems[index]["item_name"]} (x$itemCount) added to Cart',
                                    context);
                                Navigator.of(context).pop();
                              } else {
                                showCartToast("Quantity is nil", context);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined),
                                SizedBox(width: 10),
                                Text("Add To Cart"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ));
        },
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
              achievementSnackbar("Way to Bulldoze", "Stop eating ffs"));
        },
      ),
    );
  }
}
