import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  //controller
  final searchController = TextEditingController();
  String shopName = "";
  Future<List<Map<String, dynamic>>>? shopItems;

  //initState
  @override
  void initState() {
    _fetchDetails();
    super.initState();
  }

  //get details
  Future<void> _fetchDetails() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
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
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(72),
              child: ListTile(
                tileColor: Colors.amber,
                title: Text("Mayur's Paradise"),
                subtitle: Text("Manage your Store"),
              ),
            )),
        body: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0), child: Text('Store Items')),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Item $index"),
                    subtitle: Text("Description of Item $index"),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
