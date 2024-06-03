class CartItem {
  final String title;
  final int quantity;
  final int price;
  final String shopName;

  CartItem(
    this.shopName, {
    required this.title,
    required this.quantity,
    required this.price,
  });

  int get totalPrice {
    return (price * quantity).floor();
  }

  @override
  String toString() {
    return 'CartItem{title: $title, quantity: $quantity, price: $price, shopName: $shopName}';
  }

  //from json
  CartItem.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        quantity = json['quantity'] as int,
        price = json['price'] as int,
        shopName = json['shopName'] as String;
}
