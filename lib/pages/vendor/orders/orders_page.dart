import 'package:Eat.Caias/constants.dart';
import 'package:Eat.Caias/pages/vendor/orders/edit_order_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  //manipulatables
  late Map<String, dynamic> _vendorUserDetails = {};
  late Map<String, dynamic> _shopDetails = {};
  late List<Map<String, dynamic>> _shopItems = [];
  late List<Map<String, dynamic>> _allShopOrders = [];

  //vars
  String? shopName;

  Future<void> _fetchShopOrders() async {
    try {
      debugPrint("inside fetchTickets");
      final data =
          await supabase.from('ticket').select().eq('shop_name', shopName!);
      int pendingCount = 0;
      for (var element in data) {
        if (element["status"] == "Pending") {
          pendingCount++;
        }
      }
      setState(() {
        pendingOrderCount = pendingCount;
      });

      if (data.isNotEmpty) {
        debugPrint("data is not empty");
        data.sort((a, b) => b["created_at"].compareTo(a["created_at"]));
        setState(() {
          _allShopOrders = data;
        });
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        debugPrint("error boy");
        _allShopOrders = [];
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar(error.message));
      }
    } catch (error) {
      if (mounted) {
        _allShopOrders = [];
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar('Unexpected error occurred'));
      }
    }
  }

  @override
  void initState() {
    _fetchDetails().then((value) => _fetchShopOrders());
    setState(() {
      pendingOrderCount = _allShopOrders.length;
    });
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
          shopName = data["shop_name"];
          debugPrint(shopName);
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

  //var
  int pendingOrderCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'my store',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          vendorListTile(_shopDetails, _vendorUserDetails),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('Incoming Orders'),
            trailing: Chip(
                label: Text("${pendingOrderCount.toString()} orders pending")),
          ),
          Expanded(
            child: _shopItems.isNotEmpty
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _allShopOrders.length,
                    itemBuilder: (context, index) {
                      var item = _allShopOrders[index];

                      return getTicketListTile(item);
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              pendingOrderCount = 0;
            });
            _fetchShopOrders().then((value) => Get.showSnackbar(
                normalGetSnackBar(
                    "Refreshing...", "Get ready to recieve orders!")));
          },
          child: const Icon(Icons.refresh_outlined)),
    );
  }

  Widget getTicketListTile(Map<String, dynamic> item) {
    var timestamp = DateTime.parse(item["created_at"]).toLocal();
    debugPrint((timestamp.day).toString());
    return Visibility(
      visible: item["status"] != "Delivered",
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.orange.shade100,
              ]),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  item["item_name"] + " (x${item["quantity"].toString()})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text("from ${item["shop_name"]}"),
                trailing: Text(
                  "₹${item["total_price"].toString()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.timer_sharp),
                title: Text('Status: ${item["status"]}'),
                subtitle: Text(
                    "by ${item["user_name"]} on ${timestamp.day}/${timestamp.month}/${timestamp.year} at ${(timestamp.hour) % 12}:${timestamp.minute} "),
                trailing: ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => EditOrderPage(item: item),
                            ),
                          )
                          .then((value) => _fetchShopOrders());
                    },
                    child: const Icon(Icons.edit_note_rounded)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
