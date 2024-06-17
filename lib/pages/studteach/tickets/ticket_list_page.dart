import 'package:flutter/material.dart';
import 'package:Eat.Caias/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  String? username;
  List<Map<String, dynamic>>? _allTickets;
  Future<void> _fetchTickets() async {
    try {
      debugPrint("inside fetchTickets");
      final data =
          await supabase.from('ticket').select().eq('user_name', username!);

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

  Future<void> _fetchUsername() async {
    try {
      final user = supabase.auth.currentUser!;
      final response = await supabase
          .from('studteach_user')
          .select()
          .eq('email', user.email!)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          username = (response['username'] ?? " ") as String;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Username is null')));
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
  void initState() {
    _fetchUsername().then((value) => _fetchTickets());
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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.amber,
                Colors.orange,
              ])),
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("${_allTickets?.length ?? 0} pending orders",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                // trailing: ElevatedButton(
                //     onPressed: () {},
                //     child: const Icon(Icons.refresh_outlined)),
                trailing: ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history),
                        SizedBox(width: 5),
                        Text("History"),
                      ],
                    )),
              ),
            )),
      ),
      body: _allTickets != null
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _allTickets!.length,
              itemBuilder: (context, index) {
                var item = _allTickets![index];
                return getTicketListTile(item);
              },
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _fetchTickets();
            ScaffoldMessenger.of(context)
                .showSnackBar(normalSnackBar("Refreshing..."));
          },
          child: const Icon(Icons.refresh)),
    );
  }

  Widget getTicketListTile(Map<String, dynamic> item) {
    var timestamp = DateTime.parse(item["created_at"]).toLocal();
    debugPrint((timestamp.day).toString());
    return Visibility(
      visible: item["status"] != "Delivered",
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 0),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.orange.shade100,
              ]),
              borderRadius: BorderRadius.circular(6)),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${item["status"]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: dialogPadding,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Ticket Details",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  _fetchTickets().then(
                                                      (value) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                                child: const Text(
                                                    "Refresh Status"))
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        Text("Item Name: ${item["item_name"]}"),
                                        Text("Shop Name: ${item["shop_name"]}"),
                                        Text("Quantity: ${item["quantity"]}"),
                                        const Divider(),
                                        Text(
                                            "Total Price: ₹${item["total_price"]}.00"),
                                        Text("Status: ${item["status"]}"),
                                        Text(
                                            "Ordered on: ${timestamp.day}/${timestamp.month}/${timestamp.year} at ${(timestamp.hour) % 12}:${timestamp.minute} "),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text("Cancel Order")),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
