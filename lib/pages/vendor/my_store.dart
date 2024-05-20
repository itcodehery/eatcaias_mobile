import 'package:flutter/material.dart';

class MyStore extends StatelessWidget {
  const MyStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eat.caias / my store'),
      ),
      body: const Center(
        child: Text('My Store'),
      ),
    );
  }
}
