import 'package:eat_caias/models/ticket_item.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  RxList<TicketItem> allUserTickets = RxList<TicketItem>([]);

  void addToTicketList(
      String itemName, int quantity, int price, String shopName) {
    allUserTickets.add(TicketItem(shopName,
        title: itemName, quantity: quantity, price: price));
  }

  void removeFromTickets(String itemName) {
    allUserTickets.removeWhere((element) => element.title == itemName);
  }

  void purgeCart() {
    allUserTickets.clear();
  }

  int get totalCartPrice {
    return allUserTickets.fold(0, (previousValue, element) {
      return previousValue + element.totalPrice;
    });
  }
}
