import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/vendor/my_store.dart';
import 'package:Eat.Caias/pages/vendor/orders/orders_page.dart';
import 'package:Eat.Caias/pages/vendor/vendor_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VWidgetTree extends StatefulWidget {
  const VWidgetTree({Key? key}) : super(key: key);

  @override
  _VWidgetTreeState createState() => _VWidgetTreeState();
}

class _VWidgetTreeState extends State<VWidgetTree> {
  //manipulatables
  late Map<String, dynamic> _vendorUserDetails = {};
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];

  //variables
  int currentIndex = 0;

  @override
  void initState() {
    _fetchDetails();
    super.initState();
  }

  Future<void> _fetchDetails() async {
    try {
      final useremail = supabase.auth.currentUser!.email;
      final data = await supabase
          .from('vendor_user')
          .select()
          .eq('email', useremail!)
          .single();

      if (data.isNotEmpty) {
        setState(() {
          _vendorUserDetails = data;
        });
        final shopDeets = await supabase
            .from('canteen_shop')
            .select()
            .eq('shop_name', data["shop_name"])
            .single();
        final items = await supabase
            .from('menu_item')
            .select()
            .eq('shop_name', data["shop_name"]);
        setState(() {
          _shopItems = items;
          _shopItems.sort(
              (a, b) => a["item_name"].toString().compareTo(b["item_name"]));
          _shopDetails = shopDeets;
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
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: FaIcon(FontAwesomeIcons.ticket),
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
