import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  String username = "Not available";

  @override
  void initState() {
    _fetchUsername();
    super.initState();
  }

  Future<void> _fetchUsername() async {
    try {
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
            username = (response['username'] ?? " ") as String;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Username is null')));
        }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'my profile',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Hari"),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout),
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
                                    style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: const ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                    ),
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
              title: const Text(
                'Log Out',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              title: const Text(
                'Settings',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
