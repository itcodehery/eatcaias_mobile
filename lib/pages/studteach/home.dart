import 'package:eat_caias/constants.dart';
import 'package:eat_caias/pages/studteach/shop_details_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
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
  int points = 0;

  //fetch shops
  Future<void> _fetchShops() async {
    try {
      final data = await supabase.from('canteen_shop').select();
      final offers = await supabase.from('offers').select();
      final userData = await supabase
          .from('studteach_user')
          .select()
          .eq('email', supabase.auth.currentUser?.email as String)
          .single();
      if (data.isNotEmpty) {
        setState(() {
          _listOfShops = data;
          _listOfShops.sort(
              (a, b) => a["shop_name"].toString().compareTo(b["shop_name"]));
          points = userData["points"] as int;
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
        title: mainLogoMark(),
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
          pointsTag(points, context),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              icon: Icon(Icons.account_circle, color: Colors.amber.shade700))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            _listOfShops.isEmpty
                ? Padding(
                    padding: cardPadding,
                    child: Container(),
                  )
                : ListTile(
                    title: const Text('Browse through Canteens'),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline_rounded),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Padding(
                                padding: dialogPadding,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Canteens',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Browse through the list of canteens available in the campus. Click on a canteen to view the menu.',
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
            _listOfShops.isNotEmpty
                ? Padding(
                    padding:
                        cardPadding.add(const EdgeInsets.only(bottom: 80.0)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listOfShops.length,
                      itemBuilder: (context, index) {
                        return getCustomListTile(index);
                      },
                    ),
                  )
                : Padding(
                    padding: cardPadding,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: cardPadding,
                            child: Shimmer(
                              duration: const Duration(seconds: 2),
                              color: Colors.amber.shade500,
                              child: const ListTile(
                                  title: SizedBox(), subtitle: SizedBox()),
                            ),
                          );
                        }),
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
    return Padding(
      padding: cardPadding,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.amber.shade100,
            Colors.orange.shade100,
          ]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
            title: Row(
              children: [
                isOpenTag(_listOfShops[index]["is_open"] as bool),
                const SizedBox(width: 10),
                Text(
                  _listOfShops[index]["shop_name"] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            subtitle: Text(
              _listOfShops[index]["description"] as String,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopDetailsPage(
                    shopName: _listOfShops[index]["shop_name"] as String,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
