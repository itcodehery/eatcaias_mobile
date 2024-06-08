import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/vendor/add_item_page.dart';
import 'package:Eat.Caias/pages/vendor/edit_item_page.dart';
import 'package:flutter/material.dart';
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
              child: ListTile(
                tileColor: Colors.amber,
                title: Text(_shopDetails["shop_name"] ?? "",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: brownTextStyle.color,
                    )),
                subtitle: _shopDetails.isNotEmpty
                    ? Text(
                        "Manage your store, ${_vendorUserDetails["vendorname"]}!")
                    : null,
              ),
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
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh')),
            ),
            Expanded(
              child: _shopItems.isNotEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditItemPage(
                                shopName: _shopDetails["shop_name"],
                                itemName: _shopItems[index]["item_name"],
                                itemDescription: _shopItems[index]
                                    ["description"],
                                itemPrice: _shopItems[index]["price"] as int,
                                isVeg: _shopItems[index]["is_veg"] as bool,
                                isInStock: _shopItems[index]["is_inStock"],
                              ),
                            ));
                          },
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            TextButton(
              child: const Text('Go to 404'),
              onPressed: () => Navigator.of(context).pushNamed("/404"),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AddItemPage(shopName: _shopDetails["shop_name"]),
            ));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ));
  }
}
