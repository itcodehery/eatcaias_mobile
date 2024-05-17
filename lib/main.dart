import 'package:Eat.Caias/pages/studteach/home.dart';
import 'package:Eat.Caias/pages/studteach/studlogin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EatCAIAS());
}

class EatCAIAS extends StatelessWidget {
  const EatCAIAS({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat.CAIAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const Studlogin(),
      routes: {"/home": (context) => const Home()},
    );
  }
}
