import 'package:eat_caias/constants.dart';
import 'package:eat_caias/models/cart_item.dart';
import 'package:eat_caias/models/menu_item.dart';
import 'package:eat_caias/pages/studteach/cart/cart_controller.dart';
import 'package:eat_caias/pages/studteach/item_details_page.dart';
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
  //manips
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];

  //vars
  FilterMenuItem _selectedFilter = FilterMenuItem.atoz;

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
          ListTile(
            title: const Text('Items available'),
            trailing: ElevatedButton(
              style: elevatedButtonStyle.copyWith(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.amber.shade200)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Padding(
                            padding: dialogPadding,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Sort & Filter",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown.shade600,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  RadioListTile(
                                      title: const Text("Ascending"),
                                      value: FilterMenuItem.atoz,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter = FilterMenuItem.atoz;
                                          _fetchShopItems().then((value) =>
                                              _shopItems.sort((a, b) =>
                                                  a["item_name"]
                                                      .toString()
                                                      .compareTo(
                                                          b["item_name"])));
                                        });
                                        Navigator.pop(context);
                                      }),
                                  RadioListTile(
                                      title: const Text("Descending"),
                                      value: FilterMenuItem.ztoa,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter = FilterMenuItem.ztoa;
                                          _fetchShopItems().then((value) =>
                                              _shopItems.sort((a, b) =>
                                                  b["item_name"]
                                                      .toString()
                                                      .compareTo(
                                                          a["item_name"])));
                                        });
                                        Navigator.pop(context);
                                      }),
                                  RadioListTile(
                                      title: const Text("Only Veg Items"),
                                      value: FilterMenuItem.vegOnly,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter =
                                              FilterMenuItem.vegOnly;
                                          _fetchShopItems().then((value) =>
                                              _shopItems = _shopItems
                                                  .where((element) =>
                                                      element["is_veg"] as bool)
                                                  .toList());
                                        });
                                        Navigator.pop(context);
                                      }),
                                  RadioListTile(
                                      title: const Text("Only Non Veg"),
                                      value: FilterMenuItem.nonVegOnly,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter =
                                              FilterMenuItem.nonVegOnly;
                                          _fetchShopItems().then((value) =>
                                              _shopItems = _shopItems
                                                  .where((element) =>
                                                      !(element["is_veg"]
                                                          as bool))
                                                  .toList());
                                        });
                                        Navigator.pop(context);
                                      }),
                                  RadioListTile(
                                      title: const Text("In Stock"),
                                      value: FilterMenuItem.inStock,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter =
                                              FilterMenuItem.inStock;
                                          _fetchShopItems().then((value) =>
                                              _shopItems = _shopItems
                                                  .where((element) =>
                                                      element["is_inStock"]
                                                          as bool)
                                                  .toList());
                                        });
                                        Navigator.pop(context);
                                      }),
                                  RadioListTile(
                                      title: const Text("Not In Stock"),
                                      value: FilterMenuItem.outOfStock,
                                      groupValue: _selectedFilter,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFilter =
                                              FilterMenuItem.outOfStock;
                                          _fetchShopItems().then((value) =>
                                              _shopItems = _shopItems
                                                  .where((element) =>
                                                      !(element["is_inStock"]
                                                          as bool))
                                                  .toList());
                                        });
                                        Navigator.pop(context);
                                      }),
                                ]),
                          ),
                        ));
              },
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),
          _shopItems.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _shopItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: _shopItems.length,
                          itemBuilder: (context, index) {
                            return getCustomListTile(
                                index, _shopDetails['is_open']! as bool);
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

  Widget getCustomListTile(int index, bool isShopOpen) {
    Map<String, dynamic> item = _shopItems[index];
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
        enabled: item["is_inStock"] as bool,
        tileColor: Colors.white,
        title:
            Text(item["item_name"]! as String, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          item["is_inStock"] as bool
              ? item["description"]! as String
              : "OUT OF STOCK",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isVegTag(item["is_veg"] as bool),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemDetailsPage(
                    item: MenuItem.fromJson(item),
                    shopIsOpen: isShopOpen,
                  )));
        },
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
              achievementSnackbar("Way to Bulldoze", "Stop eating ffs"));
        },
      ),
    );
  }
}
