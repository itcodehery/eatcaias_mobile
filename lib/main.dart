import 'package:eat_caias/pages/common/four_o_four.dart';
import 'package:eat_caias/pages/common/splash_page.dart';
import 'package:eat_caias/pages/studteach/achievements_page.dart';
import 'package:eat_caias/pages/studteach/search_page.dart';
import 'package:get/get.dart';
import 'package:eat_caias/pages/common/settings_page.dart';
import 'package:eat_caias/pages/common/profile_page.dart';
import 'package:eat_caias/pages/studteach/cart/cart_page.dart';
import 'package:eat_caias/pages/studteach/home.dart';
import 'package:eat_caias/pages/studteach/studlogin.dart';
import 'package:eat_caias/pages/common/usertype_page.dart';
import 'package:eat_caias/pages/vendor/v_widget_tree.dart';
import 'package:eat_caias/pages/vendor/vendor_login.dart';
import 'package:eat_caias/pages/studteach/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//integrate supabase with flutter
//https://youtu.be/r7ysVtZ5Row?si=D32Lyp23Kb_q1r5J

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env["PROJ_URL"]!,
    anonKey: dotenv.env["PROJ_API_KEY"]!,
  );
  runApp(const EatCAIAS());
}

class EatCAIAS extends StatelessWidget {
  const EatCAIAS({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Eat.CAIAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
          fontFamily: 'Outfit'),
      home: const SplashPage(),
      routes: {
        "/home": (context) => const Home(),
        "/splash": (context) => const SplashPage(),
        "/loginas": (context) => const UsertypePage(),
        "/search": (context) => const SearchPage(),
        "/vendorlogin": (context) => const VendorLogin(),
        "/login": (context) => const Studlogin(),
        "/widget_tree": (context) => const WidgetTree(),
        "/vwidget_tree": (context) => const VWidgetTree(),
        "/profile": (context) => const ProfilePage(),
        "/settings": (context) => const SettingsPage(),
        "/cart": (context) => const CartPage(),
        "/404": (context) => const FourOFour(),
        "/achievements": (context) => const AchievementsPage(),
      },
      onUnknownRoute: (settings) {
        Navigator.of(context).pushNamed("/404");
        return null;
      },
    );
  }
}
