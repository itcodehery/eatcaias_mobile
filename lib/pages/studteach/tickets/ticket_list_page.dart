import 'package:flutter/material.dart';
import 'package:Eat.Caias/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  late List<Map<String, dynamic>> _allTickets = [];
  Future<void> _fetchTickets() async {
    try {
      final data = await supabase
          .from('tickets')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      if (data.isNotEmpty) {
        setState(() {
          _allTickets = data;
        });
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        errorSnackbar(error.message);
      }
    } catch (error) {
      if (mounted) {
        errorSnackbar('Unexpected error occurred');
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _allTickets.isNotEmpty
              ? ListView.builder(itemBuilder: (context, index) {
                  return const ListTile(
                    title: Text('Hey'),
                  );
                })
              : const LinearProgressIndicator(),
        ));
  }
}
