import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  //controller
  final searchController = TextEditingController();

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
      ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.amber,
              Colors.orange,
            ])),
            height: 160,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mayur's Paradise",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("Manage your Store")
                ],
              ),
            ),
          ),
          SingleChildScrollView(
              child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ListTile(title: Text('Yoo'));
            },
          ))
        ],
      ),
    );
  }
}
