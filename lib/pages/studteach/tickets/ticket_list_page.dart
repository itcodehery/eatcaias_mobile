import 'package:flutter/material.dart';
import 'package:Eat.Caias/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_material/ticket_material.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  List<Map<String, dynamic>>? _allTickets;
  Future<void> _fetchTickets() async {
    try {
      debugPrint("inside fetchTickets");
      final data = await supabase.from('ticket').select();

      if (data.isNotEmpty) {
        debugPrint("data is not empty");
        setState(() {
          _allTickets = data;
        });
      }
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

  @override
  void initState() {
    _fetchTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('eat.caias / '),
              Text(
                'my tickets',
                style: TextStyle(color: Colors.amber.shade800),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _allTickets != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                          itemCount: _allTickets!.length,
                          itemBuilder: (context, index) {
                            var item = _allTickets![index];
                            return TicketMaterial(
                                height: 140,
                                leftChild: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(item["item_names"]),
                                      subtitle:
                                          Text("from ${item["shop_name"]}"),
                                    ),
                                    ListTile(title: statusTag(item["status"])),
                                  ],
                                ),
                                rightChild: Container(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {},
                                  ),
                                ),
                                radiusBorder: 14,
                                tapHandler: () {},
                                colorBackground: Colors.white);
                          }),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ));
  }

  Widget statusTag(String status) {
    switch (status) {
      case "Pending":
        return Container(
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.amber.shade600),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text("PENDING",
                style: TextStyle(
                  color: Colors.amber.shade600,
                )),
          ),
        );

      case "Ready to Collect":
        return Container(
          height: 14,
          decoration: const BoxDecoration(
              // border: Border.all(width: 2, color: Colors.amber.shade600)
              gradient: LinearGradient(colors: [
            Colors.green,
            Color.fromARGB(255, 5, 248, 187),
          ])),
          child: const Text("READY",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        );

      default:
        return Container();
    }
  }
}
