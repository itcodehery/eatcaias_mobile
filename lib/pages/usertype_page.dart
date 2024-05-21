import 'package:flutter/material.dart';

class UsertypePage extends StatelessWidget {
  const UsertypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('eat.caias'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login as Vendor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/login");
              },
              child: const Text('Login as Student/Staff'),
            )
          ],
        ),
      ),
    );
  }
}
