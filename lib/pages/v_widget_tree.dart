import 'package:Eat.Caias/pages/studteach/home.dart';
import 'package:Eat.Caias/pages/studteach/studlogin.dart';
import 'package:Eat.Caias/pages/stores_page.dart';
import 'package:Eat.Caias/pages/vendor/my_store.dart';
import 'package:Eat.Caias/pages/vendor/vendor_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VWidgetTree extends StatefulWidget {
  const VWidgetTree({Key? key}) : super(key: key);

  @override
  _VWidgetTreeState createState() => _VWidgetTreeState();
}

class _VWidgetTreeState extends State<VWidgetTree> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const VendorHome(),
        const StoresPage(),
        const MyStore(),
      ][_currentIndex],
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: FaIcon(FontAwesomeIcons.ticket),
              icon: FaIcon(FontAwesomeIcons.ticket),
              label: "Tickets",
            ),
            NavigationDestination(
              icon: Icon(Icons.store),
              label: "Your Store",
            ),
          ]),
    );
  }
}
