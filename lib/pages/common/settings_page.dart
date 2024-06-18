import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<IconData, String> settings = {};

  @override
  void initState() {
    super.initState();
    settings = settingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'settings',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: settingList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(settings[settings.keys.elementAt(index)]!),
            leading: Icon(settings.entries.elementAt(index).key),
            onTap: () {},
          );
        },
      ),
    );
  }
}
