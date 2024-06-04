class TicketItem {
  final String title;
  final int quantity;
  final int price;
  final String shopName;

  TicketItem(
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
    return 'TicketItem{title: $title, quantity: $quantity, price: $price, shopName: $shopName}';
  }
}
