import 'package:flutter/material.dart';

class VendorCreateStore extends StatelessWidget {
  const VendorCreateStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eat.caias / create store'),
      ),
      body: const Center(
          child: Column(
        children: [Text('Register your store')],
      )),
    );
  }
}
