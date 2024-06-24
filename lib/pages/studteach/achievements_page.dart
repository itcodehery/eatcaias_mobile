import 'package:eat_caias/constants.dart';
import 'package:eat_caias/helper/achievements_helper.dart';
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
    return Padding(
      padding: cardPadding,
      child: Card(
        color: Colors.amber.shade100,
        child: ListTile(
          title: Row(
            children: [
              const Icon(Icons.emoji_events_outlined),
              const SizedBox(width: 10),
              Text(name),
            ],
          ),
          subtitle: Text(description),
          trailing: Text(achievedOn),
          onTap: () {},
        ),
      ),
    );
  }
}
