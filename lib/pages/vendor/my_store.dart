import 'package:flutter/material.dart';

class MyStore extends StatelessWidget {
  const MyStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'my store',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: const Center(
        child: Text('My Store'),
      ),
    );
  }
}
