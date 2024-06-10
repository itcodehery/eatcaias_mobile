import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/cart/cart_controller.dart';
import 'package:Eat.Caias/pages/studteach/shop_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SearchType { food, shop }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //variables
  List<Map<String, dynamic>> _shopItems = [];
  List<Map<String, dynamic>> _shopList = [];
  String _input = '';
  bool isFoodQuery = true;
  SearchType _selectedSearchType = SearchType.food;
  final TextEditingController _searchController = TextEditingController();

  //search function
  Future<void> _searchInShopItems(String itemName) async {
    try {
      final shopItems = await supabase
          .from('menu_item')
          .select()
          .textSearch('item_name', itemName);

      if (shopItems.isNotEmpty) {
        setState(() {
          _shopItems = shopItems;
        });
      } else {
        setState(() {
          _shopItems = [];
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
          content: const Text('Unexpected error occurred while fetching items'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Future<void> _searchShops(String shopName) async {
    try {
      final canteenShops = await supabase
          .from('canteen_shop')
          .select()
          .textSearch('shop_name', shopName);

      if (canteenShops.isNotEmpty) {
        setState(() {
          _shopList = canteenShops;
        });
      } else {
        setState(() {
          _shopList = [];
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
          content: const Text('Unexpected error occurred while fetching items'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Form(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Search for canteens or food',
                  border: InputBorder.none),
              controller: _searchController,
              onFieldSubmitted: (value) {
                setState(() {
                  _input = value;
                });
                _searchInShopItems(value);
                _searchShops(value);
              },
            ),
          ),
        )),
        body: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                title: const Text('Search Type'),
                trailing: SegmentedButton(
                  style: ButtonStyle(
                      side: MaterialStatePropertyAll(BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 0,
                      )),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary)),
                  segments: const [
                    ButtonSegment(value: SearchType.food, label: Text('Food')),
                    ButtonSegment(value: SearchType.shop, label: Text('Shop'))
                  ],
                  selected: <SearchType>{_selectedSearchType},
                  selectedIcon: const Icon(Icons.food_bank_outlined),
                  onSelectionChanged: (Set<SearchType> newSelection) {
                    setState(() {
                      _input = '';
                      _shopItems = [];
                      _shopList = [];
                      _searchController.text = "";
                      isFoodQuery = !isFoodQuery;
                      _selectedSearchType = newSelection.first;
                    });
                  },
                ),
              ),
            ),
          ),
          isFoodQuery
              ? (_shopItems).isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: _shopItems.length,
                      itemBuilder: (context, index) {
                        return foodListTile(
                            _shopItems[index]['item_name'].toString(),
                            _shopItems[index]['price'].toString(),
                            _shopItems[index]['shop_name'].toString(),
                            index);
                      },
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No food for '$_input'",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))
              : (_shopList).isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                      itemCount: _shopList.length,
                      itemBuilder: (context, index) {
                        return shopListTile(
                            _shopList[index]['shop_name'].toString(),
                            _shopList[index]['description'].toString());
                      },
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No canteens for '$_input'",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )),
        ]));
  }

  Widget foodListTile(
      String itemName, String itemPrice, String shopName, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Card(
        color: Colors.amber.shade100,
        child: ListTile(
          title: Text(
            itemName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("from $shopName"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("₹$itemPrice", style: const TextStyle(fontSize: 22)),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            var itemCount = 0;
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
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.zero)),
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
                            Row(
                              children: [
                                isVegTag(_shopItems[index]["is_veg"] as bool),
                                const SizedBox(width: 10),
                                Text("from $shopName"),
                              ],
                            ),
                            Text(_shopItems[index]["description"]! as String),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹${_shopItems[index]["price"] as int}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (itemCount > 0) {
                                              setState(() {
                                                itemCount = 0;
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
                                if (itemCount != 0) {
                                  Get.find<CartController>().addToCart(
                                      _shopItems[index]["item_name"] as String,
                                      itemCount,
                                      _shopItems[index]["price"] as int,
                                      shopName);
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
        ),
      ),
    );
  }

  Widget shopListTile(String shopName, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Card(
        color: Colors.amber.shade100,
        child: ListTile(
          title: Text(
            shopName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(description),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShopDetailsPage(
                  shopName: shopName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
