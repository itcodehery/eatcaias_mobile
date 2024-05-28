import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;

const formPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

const primaryColor = Colors.amber;

const secondaryColor = Colors.brown;

final tertiaryColor = Colors.amber.shade700;

var brownTextStyle = TextStyle(
  color: Colors.brown.shade700,
);

SnackBar achievementSnackbar(
    String achievementName, String achievementDescription) {
  return SnackBar(
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
                style: brownTextStyle,
              ),
            ],
          ),
          Text(
            achievementName,
            style: TextStyle(
              color: Colors.brown.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(achievementDescription, style: brownTextStyle),
        ],
      ));
}
