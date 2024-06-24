import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyStore extends StatefulWidget {
  const MyStore({Key? key}) : super(key: key);

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  //manipulatables
  late Map<String, dynamic> _vendorUserDetails = {};
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];

  @override
  void initState() {
    _fetchDetails();
    super.initState();
  }

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

  //grid_map
  final Map<String, dynamic> gridActions = {
    "Check Inventory": {
      "icon": Icons.inventory,
      "color": Colors.amber,
      "route": "/inventory"
    },
    "Add Item": {
      "icon": Icons.add,
      "color": Colors.amber,
      "route": "/add_item"
    },
    "Edit Item": {
      "icon": Icons.edit,
      "color": Colors.amber,
      "route": "/edit_item"
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'my store',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          vendorListTile(_shopDetails, _vendorUserDetails, "inventory"),
          const SizedBox(height: 10),
          const ListTile(
            title: Text('Manage Inventory'),
          ),
          Expanded(
            child: _shopItems.isNotEmpty
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _shopItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(_shopItems[index]["item_name"] ?? "",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: brownTextStyle.color)),
                              subtitle:
                                  Text("₹ ${_shopItems[index]["price"] ?? ""}"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      "/edit_item",
                                      arguments: _shopItems[index],
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      "/delete_item",
                                      arguments: _shopItems[index],
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
