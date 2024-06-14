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
    _fetchUsername();
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
                    "${timestamp.day}/${timestamp.month}/${timestamp.year} at ${(timestamp.hour) % 12}:${timestamp.minute} "),
                trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.refresh_outlined)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
