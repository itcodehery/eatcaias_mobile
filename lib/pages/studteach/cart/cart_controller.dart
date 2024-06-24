import 'package:eat_caias/models/cart_item.dart';
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

  Map<String, int> get shopNamesAndPrices {
    Map<String, int> shopNamesAndPrices = {};
    for (var element in cartItems) {
      if (shopNamesAndPrices.containsKey(element.shopName)) {
        shopNamesAndPrices[element.shopName] =
            shopNamesAndPrices[element.shopName]! + element.totalPrice;
      } else {
        shopNamesAndPrices[element.shopName] = element.totalPrice;
      }
    }
    return shopNamesAndPrices;
  }

  int get totalCartPrice {
    return cartItems.fold(0, (previousValue, element) {
      return previousValue + element.totalPrice;
    });
  }
}
