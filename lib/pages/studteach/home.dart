import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //constants
  final _mainButtonsStyle = const ButtonStyle(
    fixedSize: MaterialStatePropertyAll(Size(150, 50)),
    minimumSize: MaterialStatePropertyAll(Size(120, 40)),
    elevation: MaterialStatePropertyAll(0),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
    ),
  );

  //main builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eat.caias'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.airplane_ticket_outlined))
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
