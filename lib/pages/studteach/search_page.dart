import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/shop_details_page.dart';
import 'package:flutter/material.dart';
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
                            _shopItems[index]['shop_name'].toString());
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

  Widget foodListTile(String itemName, String itemPrice, String shopName) {
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
          trailing: Text("₹$itemPrice", style: const TextStyle(fontSize: 22)),
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
