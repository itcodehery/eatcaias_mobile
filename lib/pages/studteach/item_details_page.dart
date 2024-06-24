import 'package:eat_caias/models/cart_item.dart';
import 'package:eat_caias/models/menu_item.dart';
import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  final MenuItem item;

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String? itemImageURL;

  Future<void> getImageURL() async {
    Future.delayed(Durations.extralong4).then((value) {
      setState(() {
        itemImageURL = widget.item.imageUrl;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
      ),
      body: Column(
        children: [
          itemImageURL != null
              ? Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage(itemImageURL!))),
                )
              : Container(),
          Text(widget.item.itemName),
          Text(widget.item.description),
        ],
      ),
    );
  }
}
