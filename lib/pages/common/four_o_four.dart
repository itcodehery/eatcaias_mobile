import 'package:flutter/material.dart';

class FourOFour extends StatelessWidget {
  const FourOFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          image: const DecorationImage(
              image: AssetImage('../assets/four-o-four.jpeg'),
              fit: BoxFit.cover),
        ),
      )),
    );
  }
}
