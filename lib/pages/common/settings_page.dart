import 'package:Eat.Caias/helper/settings_list.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final listOfSettings = Settings().settingList;
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
        itemCount: listOfSettings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listOfSettings[index]!),
            leading: Icon(listOfSettings.entries.elementAt(index).key),
          );
        },
      ),
    );
  }
}
