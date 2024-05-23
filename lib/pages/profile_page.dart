import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  String? username;
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fetchUsername();
    super.initState();
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
            ListTile(
              title: const Text("Logged in as"),
              subtitle: Text(supabase.auth.currentUser!.email!),
              trailing: Icon(Icons.verified, color: Colors.brown.shade700),
            ),
            ListTile(
              title: const Text("Profile created at"),
              subtitle: Text(supabase.auth.currentUser!.createdAt),
            ),
            ListTile(
              title: const Text("Authentication State"),
              subtitle: Text(supabase.auth.currentUser!.aud),
            ),
            ListTile(
              onLongPress: () {
                var textStyle = TextStyle(
                  color: Colors.brown.shade700,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 6),
                    backgroundColor: Colors.amber,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.celebration_outlined),
                            const SizedBox(width: 10),
                            Text(
                              'Achievement Unlocked!',
                              style: textStyle,
                            ),
                          ],
                        ),
                        Text(
                          "Self-Obsessed",
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text('Long press your name for some reason idk.',
                            style: textStyle),
                      ],
                    )));
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text('Edit username'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Enter a new username:'),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                  await supabase
                                      .from("studteach_user")
                                      .update({
                                        "username":
                                            _usernameController.text.trim()
                                      })
                                      .eq("email",
                                          supabase.auth.currentUser!.email!)
                                      .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "The value has been updated")));
                                        setState(() {
                                          username =
                                              _usernameController.text.trim();
                                        });
                                      });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              },
              title: const Text('Username'),
              subtitle: username != null
                  ? Text(username!)
                  : const LinearProgressIndicator(),
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
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
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
            const Spacer(),
            const Text("Made by Hari Prasad"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
