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

EdgeInsets dialogPadding = const EdgeInsets.all(16.0);

const mainButtonsStyle = ButtonStyle(
  fixedSize: MaterialStatePropertyAll(Size(150, 50)),
  minimumSize: MaterialStatePropertyAll(Size(120, 40)),
  elevation: MaterialStatePropertyAll(0),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
  ),
);
