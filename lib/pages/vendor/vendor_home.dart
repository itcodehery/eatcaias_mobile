import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/vendor/add_item_page.dart';
import 'package:Eat.Caias/pages/vendor/edit_item_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  //initState
  @override
  void initState() {
    _fetchDetails();
    super.initState();
  }

  //controller
  final searchController = TextEditingController();
  late Map<String, dynamic> _vendorUserDetails = {};
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];

  //newItemDetails
  final newItemNameController = TextEditingController();
  final newItemDescriptionController = TextEditingController();
  final newItemPriceController = TextEditingController();

  //get details
  Future<void> _fetchDetails() async {
    try {
      final useremail = supabase.auth.currentUser!.email;
      final data = await supabase
          .from('vendor_user')
          .select()
          .eq('email', useremail!)
          .single();

      if (data.isNotEmpty) {
        setState(() {
          _vendorUserDetails = data;
        });
        final shopDeets = await supabase
            .from('canteen_shop')
            .select()
            .eq('shop_name', data["shop_name"])
            .single();
        final items = await supabase
            .from('menu_item')
            .select()
            .eq('shop_name', data["shop_name"]);
        setState(() {
          _shopItems = [];
          _shopItems = items;
          _shopItems.sort(
              (a, b) => a["item_name"].toString().compareTo(b["item_name"]));
          _shopDetails = shopDeets;
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

  //addItemToDatabase
  Future<void> _addItemToDatabase() async {
    try {
      await supabase.from('menu_item').upsert([
        {
          'shop_name': _shopDetails["shop_name"],
          'item_name': 'item_name',
          'description': 'description',
          'price': 'price',
        }
      ]);
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

  //main builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('eat.caias'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/profile");
                  },
                  icon: const Icon(Icons.account_circle_outlined))
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: vendorListTile(_shopDetails, _vendorUserDetails, "store"),
            )),
        body: Column(
          children: [
            ListTile(
              title: const Text('Store Items'),
              trailing: ElevatedButton.icon(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.amber.shade100)),
                  onPressed: () {
                    _fetchDetails();
                    Get.showSnackbar(const GetSnackBar(
                        backgroundColor: Colors.amber,
                        duration: Duration(seconds: 4),
                        titleText: Text(
                          'Refreshed!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        messageText: Text('Store items refreshed!')));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh')),
            ),
            Expanded(
              child: _shopItems.isNotEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 60),
                      shrinkWrap: true,
                      itemCount: _shopItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            children: [
                              isVegTag(_shopItems[index]["is_veg"] as bool),
                              const SizedBox(width: 10),
                              Text(_shopItems[index]["item_name"] ??
                                  "Loading..."),
                            ],
                          ),
                          subtitle: Text(
                            _shopItems[index]["description"] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (context) => EditItemPage(
                                    shopName: _shopDetails["shop_name"],
                                    itemName: _shopItems[index]["item_name"],
                                    itemDescription: _shopItems[index]
                                        ["description"],
                                    itemPrice:
                                        _shopItems[index]["price"] as int,
                                    isVeg: _shopItems[index]["is_veg"] as bool,
                                    isInStock: _shopItems[index]["is_inStock"],
                                  ),
                                ))
                                .whenComplete(() => _fetchDetails());
                            // after the changes have been done, it refreshes the page
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: cardPadding,
                          child: Shimmer(
                            color: Colors.amber.shade600,
                            child: const ListTile(
                              title: SizedBox(),
                              subtitle: SizedBox(),
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) =>
                      AddItemPage(shopName: _shopDetails["shop_name"]),
                ))
                .whenComplete(() => _fetchDetails());
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ));
  }
}
