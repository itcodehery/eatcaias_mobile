import 'package:Eat.Caias/constants.dart';
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
          _shopDetails = data;
        });
        final items = await supabase
            .from('menu_item')
            .select()
            .eq('shop_name', data["shop_name"]);
        setState(() {
          _shopItems = items;
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
                      fontWeight: FontWeight.w500,
                      color: brownTextStyle.color,
                    )),
                subtitle: _shopDetails.isNotEmpty
                    ? const Text("Manage your Store")
                    : null,
              ),
            )),
        body: Column(
          children: [
            const ListTile(
              title: Text('Store Items'),
            ),
            Expanded(
              child: _shopItems.isNotEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _shopItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              _shopItems[index]["item_name"] ?? "Loading..."),
                          subtitle:
                              Text(_shopItems[index]["description"] ?? ""),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed("/add_item");
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ));
  }
}
