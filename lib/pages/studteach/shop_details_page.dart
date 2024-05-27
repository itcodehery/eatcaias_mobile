import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopDetailsPage extends StatefulWidget {
  const ShopDetailsPage({Key? key, required this.shopName}) : super(key: key);

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
    print(_shopItems.toString());
  }

  Future<void> _fetchShopItems() async {
    try {
      final shopItems = await supabase
          .from('menu_item')
          .select()
          .eq('shop_id', _shopDetails['id'] as int);
      if (shopItems.isNotEmpty) {
        setState(() {
          _shopItems = shopItems;
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
                        Text(_shopDetails['description'] ?? "")
                      ]),
                ),
              )),
          const Padding(
            padding: EdgeInsets.all(14.0),
            child: Text('Items available'),
          ),
          _shopItems.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
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
                  child: Text("No items available"),
                ),
        ],
      ),
    );
  }

  Widget getCustomListTile(int index) {
    return Card(
      child: ListTile(
        title: Text(_shopItems[index]["item_name"] as String),
        subtitle: Text(_shopItems[index]["description"] as String),
        leading: _shopItems[index]["is_veg"] as bool
            ? const FaIcon(
                FontAwesomeIcons.bowlFood,
                color: Colors.green,
              )
            : FaIcon(
                FontAwesomeIcons.bowlFood,
                color: Colors.red.shade900,
              ),
        trailing: Row(
          children: [
            Text(
              "₹ ${_shopItems[index]["price"]}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            )
          ],
        ),
        onTap: () {
          if (_shopItems[index]["is_InStock"] as bool) {
            CartProvider().addToCart(_shopItems[index]["item_name"]!);
          }
        },
      ),
    );
  }
}
