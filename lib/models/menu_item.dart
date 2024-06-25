import 'package:flutter/material.dart';

class MenuItem {
  final String itemName;
  final String shopName;
  final String description;
  final int price;
  final String? imageUrl;
  final bool isVeg;
  final bool isInStock;

  MenuItem(
      {required this.itemName,
      required this.shopName,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.isVeg,
      required this.isInStock});

  //from json
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemName: json['item_name'],
      shopName: json['shop_name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'],
      isVeg: json['is_veg'],
      isInStock: json['is_inStock'],
    );
  }
}
