import 'package:Eat.Caias/models/cart_item.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = RxList<CartItem>([]);

  void addToCart(String itemName, int quantity, int price, String shopName) {
    cartItems.add(
        CartItem(shopName, title: itemName, quantity: quantity, price: price));
  }

  void removeFromCart(String itemName) {
    cartItems.removeWhere((element) => element.title == itemName);
  }

  void purgeCart() {
    cartItems.clear();
  }

  int get totalCartPrice {
    return cartItems.fold(0, (previousValue, element) {
      return previousValue + element.totalPrice;
    });
  }
}
