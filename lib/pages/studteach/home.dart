import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/shop_details_page.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  //variables
  String? offer;
  late List<Map<String, dynamic>> _listOfShops = [];

  //fetch shops
  Future<void> _fetchShops() async {
    try {
      final data = await supabase.from('canteen_shop').select();
      final offers = await supabase.from('offers').select();
      if (data.isNotEmpty) {
        setState(() {
          _listOfShops = data;
        });
      } else {
        return;
      }
      if (offers.isNotEmpty) {
        setState(() {
          offer = offers.elementAt(offers.length - 1)["offer"]!;
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

  //initState
  @override
  void initState() {
    _fetchShops();
    super.initState();
  }

  //main builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eat.caias'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(85),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Search for food or canteens!'),
                      leading: const Icon(Icons.search),
                      onTap: () => Navigator.of(context).pushNamed('/search'),
                    ),
                  ),
                ],
              ),
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              icon: Icon(Icons.account_circle, color: Colors.amber.shade700))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber,
                      Colors.orange.shade500,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.maxFinite,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Today\'s Offer'),
                          content: Text(offer ?? 'No offer available'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.celebration_rounded),
                                SizedBox(width: 10),
                                Text("Today's Offer"),
                              ],
                            ),
                            offer != null
                                ? Text(
                                    offer!,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Text("Loading today's offer...")
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            const ListTile(
              title: Text('Browse through Canteens'),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.8,
            //   child: ListView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: _listOfShops.length,
            //     itemBuilder: (context, index) {
            //       return getCustomListTile(index);
            //     },
            //   ),
            // )
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: _listOfShops.length,
                itemBuilder: (context, index) {
                  return getCustomListTile(index);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        label: const Text('My Cart'),
        icon: const Icon(Icons.shopping_basket_outlined),
      ),
    );
  }

  Widget getCustomListTile(int index) {
    return Card(
      // color: Colors.random,
      color: Colors.amber.withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          )),
      child: ListTile(
          title: Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  _listOfShops[index]["shop_name"] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
          subtitle: Text(
            _listOfShops[index]["description"] as String,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShopDetailsPage(
                  shopName: _listOfShops[index]["shop_name"] as String,
                ),
              ),
            );
          }),
    );
  }
}
