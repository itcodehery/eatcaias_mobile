import 'package:Eat.Caias/helper/settings_list.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
        itemCount: Settings().settingList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(Settings().settingList[index]!),
            leading: Icon(Settings().settingList.entries.elementAt(index).key),
          );
        },
      ),
    );
  }
}
