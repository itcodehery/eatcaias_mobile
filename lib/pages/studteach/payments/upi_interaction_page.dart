import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpiInteractionPage extends StatefulWidget {
  const UpiInteractionPage({
    Key? key,
    required this.shopName,
    required this.totalPrice,
  }) : super(key: key);

  final String shopName;
  final int totalPrice;

  @override
  _UpiInteractionPageState createState() => _UpiInteractionPageState();
}

class _UpiInteractionPageState extends State<UpiInteractionPage> {
  Future<void> getUPIApps() async {}

  @override
  void initState() {
    super.initState();
    getUPIApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select your UPI App'),
        ),
        body: Container());
  }
}
