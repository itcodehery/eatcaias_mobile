import 'package:flutter/material.dart';

class MenuItem {
  final int id;
  final DateTime createdAt;
  final String itemName;
  final int shopId;
  final String description;
  final double price;
  final String imageUrl;
  final bool isVeg;
  final bool isInStock;

  MenuItem(
      {required this.id,
      required this.createdAt,
      required this.itemName,
      required this.shopId,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.isVeg,
      required this.isInStock});
}
