import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;

const formPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

const primaryColor = Colors.amber;

const secondaryColor = Colors.brown;

final tertiaryColor = Colors.amber.shade700;

enum OrderStatus {
  pending,
  cancelled,
  delivered,
  readyforpickup,
}

enum FilterMenuItem { atoz, ztoa, vegOnly, nonVegOnly, inStock, outOfStock }

enum PaymentMethod { upi, cod, cc, dc }

var brownTextStyle = TextStyle(
  color: Colors.brown.shade700,
);

var headerTextStyle = TextStyle(
  color: Colors.brown.shade800,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

var elevatedButtonStyle = ButtonStyle(
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(Colors.brown.shade800));

var iconButtonStyle = ButtonStyle(
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(Colors.brown.shade800));

SnackBar achievementSnackbar(
    String achievementName, String achievementDescription) {
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 6),
      backgroundColor: Colors.amber,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.celebration_outlined),
              const SizedBox(width: 10),
              Text(
                'Achievement Unlocked!',
                style: brownTextStyle,
              ),
            ],
          ),
          Text(
            achievementName,
            style: TextStyle(
              color: Colors.brown.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(achievementDescription, style: brownTextStyle),
        ],
      ));
}

SnackBar errorSnackbar(String errorMessage) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 6),
    backgroundColor: Colors.red,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(width: 10),
            Text(
              'Error!',
              style: brownTextStyle,
            ),
          ],
        ),
        Text(
          errorMessage,
          style: brownTextStyle,
        ),
      ],
    ),
  );
}

SnackBar normalSnackBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 6),
    backgroundColor: Colors.amber,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline),
        const SizedBox(width: 10),
        Text(
          message,
          style: brownTextStyle,
        ),
      ],
    ),
  );
}

GetSnackBar normalGetSnackBar(String title, String message) {
  return GetSnackBar(
    backgroundColor: Colors.amber.shade600,
    duration: const Duration(seconds: 3),
    titleText: Text(title,
        style:
            brownTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
    messageText: Text(
      message,
      style: brownTextStyle,
    ),
  );
}

ToastFuture showCartToast(String message, BuildContext context) {
  return showToast(message,
      context: context,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      backgroundColor: Colors.amber.shade600,
      textStyle: const TextStyle(color: Colors.black, fontSize: 14));
}

Map<IconData, String> settingList = {
  Icons.person: 'Profile',
  Icons.notifications: 'Notifications',
  Icons.lock: 'Privacy',
  Icons.language: 'Language',
};

EdgeInsets dialogPadding =
    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0);

const mainButtonsStyle = ButtonStyle(
  fixedSize: WidgetStatePropertyAll(Size(150, 50)),
  minimumSize: WidgetStatePropertyAll(Size(120, 40)),
  elevation: WidgetStatePropertyAll(0),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
  ),
);

EdgeInsets cardPadding = const EdgeInsets.symmetric(vertical: 2, horizontal: 6);

Widget pointsTag(int points, BuildContext context) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: dialogPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          mainLogoMark(),
                          const SizedBox(width: 6),
                          Text(
                            'points',
                            style: brownTextStyle.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You have $points points! Earn more points by ordering from your favourite restaurants, gathering achievements or by referring a friend and redeem them for exciting offers!',
                        style: brownTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
    },
    child: Padding(
      padding: cardPadding,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(10),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          '🔥 $points points',
          style: const TextStyle(),
        ),
      ),
    ),
  );
}

Widget isOpenTag(bool isOpen) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              isOpen ? "Open" : "Closed",
              style: TextStyle(
                  color: isOpen ? Colors.green.shade800 : Colors.red.shade800,
                  fontSize: 14),
            ))),
  );
}

Widget isVegTag(bool isVeg) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
    child: Container(
        decoration: BoxDecoration(
          color: isVeg ? Colors.green.shade600 : Colors.red.shade800,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              isVeg ? "Veg" : "Non-Veg",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ))),
  );
}

ListTile vendorListTile(Map<String, dynamic> shopDetails,
    Map<String, dynamic> vendorUserDetails, String manageType) {
  return ListTile(
    tileColor: Colors.amber,
    title: Text(shopDetails["shop_name"] ?? "",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: brownTextStyle.color,
        )),
    subtitle: shopDetails.isNotEmpty
        ? Text("Manage your $manageType, ${vendorUserDetails["vendorname"]}!")
        : null,
  );
}

Widget isStockedTag() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
    child: Container(
        decoration: BoxDecoration(
          color: tertiaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              "IN STOCK",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ))),
  );
}

Widget isPaidTag() {
  return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.amber.shade400,
          Colors.orange.shade400,
        ]),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            "PAID",
            style: TextStyle(color: Colors.black, fontSize: 14),
          )));
}

Widget mainLogoMark() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'eat.',
        style: TextStyle(
          color: Colors.brown.shade600,
          fontSize: 24,
        ),
      ),
      Text('caias',
          style: TextStyle(
            color: Colors.amber.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )),
    ],
  );
}
