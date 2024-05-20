import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eat.caias / my profile'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: const Text('Signed in as'),
              subtitle: Text(supabase.auth.currentUser!.email!),
            ),
            const ListTile(
              title: Text('Username'),
              subtitle: Text("Not available"),
            ),
            TextButton(
                onPressed: () {
                  debugPrint(supabase.auth.currentUser!
                      .userMetadata!['raw_user_meta_data']["username"]);
                },
                child: const Text("Print")),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ListTile(
                                title: Text('Log Out'),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child:
                                    Text('Are you sure you want to log out?'),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Cancel"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await supabase.auth.signOut();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ));
              },
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
