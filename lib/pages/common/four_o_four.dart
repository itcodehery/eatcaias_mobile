import 'package:flutter/material.dart';

class FourOFour extends StatelessWidget {
  const FourOFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('404 Page Not Found. Try restarting the app!'),
      ),
    );
  }
}
