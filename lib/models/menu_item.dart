import 'package:flutter/material.dart';

class MenuItem {
  final String itemName;
  final int shopId;
  final String description;
  final double price;
  final String imageUrl;
  final bool isVeg;
  final bool isInStock;

  MenuItem(
      {required this.itemName,
      required this.shopId,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.isVeg,
      required this.isInStock});

  //from json
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemName: json['itemName'],
      shopId: json['shopId'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isVeg: json['isVeg'],
      isInStock: json['isInStock'],
    );
  }
}
