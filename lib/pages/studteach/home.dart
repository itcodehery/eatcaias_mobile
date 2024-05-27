import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/studteach/shop_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  //constants
  // final _mainButtonsStyle = const ButtonStyle(
  //   fixedSize: MaterialStatePropertyAll(Size(150, 50)),
  //   minimumSize: MaterialStatePropertyAll(Size(120, 40)),
  //   elevation: MaterialStatePropertyAll(0),
  //   shape: MaterialStatePropertyAll(
  //     RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(5))),
  //   ),
  // );

  String? offer;

  late List<Map<String, dynamic>> _listOfShops = [];

  //controller
  final searchController = TextEditingController();

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
                  SearchBar(
                    controller: searchController,
                    hintText: 'Search for food or canteens',
                    leading: const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.search),
                      ],
                    ),
                    elevation: const MaterialStatePropertyAll(2),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              : const LinearProgressIndicator(
                                  color: Colors.amber,
                                ),
                        ]),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Browse through Canteens'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
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
          var textStyle = TextStyle(
            color: Colors.brown.shade700,
          );
          Navigator.of(context).pushNamed('/cart');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.amber,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.celebration_outlined),
                      const SizedBox(width: 10),
                      Text(
                        'Achievement Unlocked!',
                        style: textStyle,
                      ),
                    ],
                  ),
                  Text(
                    "Gobblin' Time",
                    style: TextStyle(
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text('Opened Cart for the First Time', style: textStyle),
                ],
              )));
        },
        label: const Text('My Cart'),
        icon: const Icon(Icons.shopping_basket_outlined),
      ),
    );
  }

  Widget getCustomListTile(int index) {
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
        title: Text(
          _listOfShops[index]["shop_name"] as String,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _listOfShops[index]["description"] as String,
        ),
        trailing: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 255, 151, 144)),
                padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                )),
                fixedSize: MaterialStatePropertyAll(Size.square(50))),
            onPressed: () {},
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            )),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShopDetailsPage(
              shopName: _listOfShops[index]["shop_name"] as String),
        )),
      ),
    );
  }
}
