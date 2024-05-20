import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  String username = "Not available";

  @override
  void initState() {
    fetchUsername();
    super.initState();
  }

  Future<void> fetchUsername() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final userId = user.id;
      final response = await supabase
          .from('studteach_user')
          .select('username')
          .eq('id', userId)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          username = response['username'];
        });
      } else {
        print('Error fetching username: Response is empty!');
      }
    }
  }

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
            ListTile(
              title: const Text('Username'),
              subtitle: Text(username),
            ),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Logged out successfully!')));
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
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
