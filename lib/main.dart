import 'package:Eat.Caias/pages/studteach/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EatCAIAS());
}

class EatCAIAS extends StatelessWidget {
  const EatCAIAS({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
