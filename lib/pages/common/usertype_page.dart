import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';

class UsertypePage extends StatefulWidget {
  const UsertypePage({Key? key}) : super(key: key);

  @override
  State<UsertypePage> createState() => _UsertypePageState();
}

class _UsertypePageState extends State<UsertypePage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    debugPrint('inside redirect!');
    final session = supabase.auth.currentSession;
    if (!mounted) return;
    if (session != null) {
      if (supabase.auth.currentUser!.email!.contains("caias.in")) {
        Navigator.of(context).pushReplacementNamed("/widget_tree");
      } else {
        Navigator.of(context).pushReplacementNamed("/vwidget_tree");
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/loginas");
    }
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle defaultButton = ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.amber),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
    );
    return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'eat.',
                  style: TextStyle(
                    color: Colors.brown.shade600,
                    fontSize: 24,
                  ),
                ),
                Text('caias',
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
              ],
            ),
            const Text('For your Canteen!'),
          ],
        )),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Login as: '),
                ElevatedButton(
                  style: defaultButton,
                  onPressed: () {
                    Navigator.of(context).pushNamed("/vendorlogin");
                  },
                  child: const Text('Vendor'),
                ),
                ElevatedButton(
                  style: defaultButton,
                  onPressed: () {
                    Navigator.of(context).pushNamed("/login");
                  },
                  child: const Text('Student/Staff'),
                )
              ],
            ),
          ),
        ));
  }
}