import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditOrderPage extends StatefulWidget {
  const EditOrderPage({Key? key, required this.item}) : super(key: key);

  final Map<String, dynamic> item;

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  //selected
  OrderStatus _selectedStatus = OrderStatus.pending;
  DateTime _itemCreatedOn = DateTime.now();

  Future<void> _updateShopOrder(String status) async {
    try {
      debugPrint("inside updateShopOrder");
      await supabase.from('ticket').update({
        "status": status,
      }).eq('id', widget.item["id"]);
    } on PostgrestException catch (error) {
      if (mounted) {
        debugPrint("error boy");

        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar(error.message));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar('Unexpected error occurred'));
      }
    }
  }

  void updateSelectedStatus() {
    String itemStatus = (widget.item["status"] as String);
    switch (itemStatus) {
      case "Pending":
        setState(() {
          _selectedStatus = OrderStatus.pending;
        });
        break;

      case "Cancelled":
        setState(() {
          _selectedStatus = OrderStatus.cancelled;
        });
        break;

      case "Ready For Pickup":
        setState(() {
          _selectedStatus = OrderStatus.readyforpickup;
        });

      case "Delivered":
        setState(() {
          _selectedStatus = OrderStatus.delivered;
        });
        break;
      default:
        null;
    }
  }

  //initState
  @override
  void initState() {
    updateSelectedStatus();
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    _itemCreatedOn = DateTime.parse(widget.item["created_at"]).toLocal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Order'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Order ID #${widget.item['id']}',
          ),
          Text(
            widget.item['item_name'] as String,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "x${widget.item["quantity"].toString()}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text("Ordered by ${widget.item['user_name']}"),
            subtitle: Text(
                "${_itemCreatedOn.day.toString()}/${_itemCreatedOn.month.toString()}/${_itemCreatedOn.year.toString()} at ${_itemCreatedOn.hour.toString()}:${_itemCreatedOn.minute.toString()}"),
            trailing: payedTag(),
          ),
          const Divider(),
          const ListTile(
            title: Text('Set Order Status'),
          ),
          RadioListTile(
            value: OrderStatus.pending,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = OrderStatus.pending;
              });
            },
            title: const Text('Pending'),
          ),
          RadioListTile(
            value: OrderStatus.readyforpickup,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = OrderStatus.readyforpickup;
              });
            },
            title: const Text('Ready for Pickup'),
          ),
          RadioListTile(
            value: OrderStatus.delivered,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = OrderStatus.delivered;
              });
            },
            title: const Text('Delivered'),
          ),
          RadioListTile(
            value: OrderStatus.cancelled,
            groupValue: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = OrderStatus.cancelled;
              });
            },
            title: const Text('Cancelled'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (con) => Dialog(
                    child: Padding(
                      padding: dialogPadding,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Save Changes',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                                "Are you sure you want to save changes?"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel')),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      _updateShopOrder(
                                              switch (_selectedStatus) {
                                        OrderStatus.delivered => "Delivered",
                                        OrderStatus.pending => "Pending",
                                        OrderStatus.cancelled => "Cancelled",
                                        OrderStatus.readyforpickup =>
                                          "Ready For Pickup"
                                      })
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Get.showSnackbar(normalGetSnackBar(
                                            "Item Updated",
                                            "${widget.item["item_name"]} has been updated"));
                                      });
                                    },
                                    child: const Text('Save')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        icon: const Icon(Icons.save_outlined),
        label: const Text("Save"),
      ),
    );
  }

  Widget payedTag() {
    return const Chip(
      label: Text(
        "PAID",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      side: BorderSide.none,
      color: WidgetStatePropertyAll(Colors.amber),
    );
  }
}
