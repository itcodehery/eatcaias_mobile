import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final supabase = Supabase.instance.client;

const formPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

const primaryColor = Colors.amber;

const secondaryColor = Colors.brown;

final tertiaryColor = Colors.amber.shade700;

var brownTextStyle = TextStyle(
  color: Colors.brown.shade700,
);

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
  fixedSize: MaterialStatePropertyAll(Size(150, 50)),
  minimumSize: MaterialStatePropertyAll(Size(120, 40)),
  elevation: MaterialStatePropertyAll(0),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
  ),
);

EdgeInsets cardPadding = const EdgeInsets.symmetric(vertical: 2, horizontal: 6);

Widget pointsTag(int points) {
  return Padding(
    padding: cardPadding,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(10),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {},
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

ListTile vendorListTile(
    Map<String, dynamic> shopDetails, Map<String, dynamic> vendorUserDetails) {
  return ListTile(
    tileColor: Colors.amber,
    title: Text(shopDetails["shop_name"] ?? "",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: brownTextStyle.color,
        )),
    subtitle: shopDetails.isNotEmpty
        ? Text("Manage your store, ${vendorUserDetails["vendorname"]}!")
        : null,
  );
}
