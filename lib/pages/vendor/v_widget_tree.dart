import 'package:eat_caias/pages/vendor/my_store.dart';
import 'package:eat_caias/pages/vendor/orders/orders_page.dart';
import 'package:eat_caias/pages/vendor/vendor_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VWidgetTree extends StatefulWidget {
  const VWidgetTree({Key? key}) : super(key: key);

  @override
  _VWidgetTreeState createState() => _VWidgetTreeState();
}

class _VWidgetTreeState extends State<VWidgetTree> {
  //variables
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const VendorHome(),
        const OrdersPage(),
        const MyStore(),
      ][currentIndex],
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.ticket),
              label: "Orders",
            ),
            NavigationDestination(
              icon: Icon(Icons.store),
              label: "Inventory",
            ),
          ]),
    );
  }
}
