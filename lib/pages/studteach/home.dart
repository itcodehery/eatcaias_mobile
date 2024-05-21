import 'package:flutter/material.dart';

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

  //controller
  final searchController = TextEditingController();

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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lmao stop eating ffs')));
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.shopping_basket_outlined),
      ),
    );
  }
}
