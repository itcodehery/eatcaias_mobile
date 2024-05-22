import 'package:Eat.Caias/main.dart';
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

  List<Map<String, dynamic>> _listOfShops = [];

  //controller
  final searchController = TextEditingController();

  //fetch shops
  Future<void> _fetchShops() async {
    try {
      final response = await supabase.from('canteen_shop').select("*");
      if (response.isNotEmpty) {
        setState(() {
          _listOfShops = response;
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
              child: SearchBar(
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
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/profile");
              },
              icon: const Icon(Icons.account_circle_outlined))
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.amber,
              Colors.orange.shade500,
            ])),
            width: double.maxFinite,
            height: 200,
            child: const Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get 10% off on Saturdays!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Offer not available at Cafe Coffee Day Cafe')
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _fetchShops(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: _listOfShops.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: _listOfShops.elementAt(index)["shop_name"],
                      trailing: const Icon(Icons.chevron_right),
                    );
                  },
                );
              },
            ),
          )
        ],
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
}
