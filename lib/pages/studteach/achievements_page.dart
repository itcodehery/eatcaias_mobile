import 'package:Eat.Caias/helper/achievements_helper.dart';
import 'package:flutter/material.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Achievements"),
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return achievementsListTile(achievements[index]["title"],
              achievements[index]["description"], "Today");
        },
      ),
    );
  }

  Widget achievementsListTile(
      String name, String description, String achievedOn) {
    return ListTile(
      title: Text(name),
      subtitle: Text(description + achievedOn),
    );
  }
}
