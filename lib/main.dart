import 'package:Eat.Caias/pages/common/settings_page.dart';
import 'package:Eat.Caias/pages/profile_page.dart';
import 'package:Eat.Caias/pages/studteach/cart_page.dart';
import 'package:Eat.Caias/pages/studteach/home.dart';
import 'package:Eat.Caias/pages/studteach/studlogin.dart';
import 'package:Eat.Caias/pages/usertype_page.dart';
import 'package:Eat.Caias/pages/vendor/v_widget_tree.dart';
import 'package:Eat.Caias/pages/vendor/vendor_login.dart';
import 'package:Eat.Caias/pages/studteach/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//integrate supabase with flutter
//https://youtu.be/r7ysVtZ5Row?si=D32Lyp23Kb_q1r5J

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize dotenv
  await dotenv.load(fileName: ".env");
  // initialize supabase
  await Supabase.initialize(
    url: dotenv.env["PROJ_URL"]!,
    anonKey: dotenv.env["PROJ_API_KEY"]!,
  );
  runApp(const EatCAIAS());
}

final supabase = Supabase.instance.client;

class EatCAIAS extends StatelessWidget {
  const EatCAIAS({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat.CAIAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
          fontFamily: 'Outfit'),
      home: const UsertypePage(),
      routes: {
        "/home": (context) => const Home(),
        "loginas": (context) => const UsertypePage(),
        "/vendorlogin": (context) => const VendorLogin(),
        "/login": (context) => const Studlogin(),
        "/widget_tree": (context) => const WidgetTree(),
        "/vwidget_tree": (context) => const VWidgetTree(),
        "/profile": (context) => const ProfilePage(),
        "/settings": (context) => const SettingsPage(),
        "/cart": (context) => const CartPage(),
      },
    );
  }
}
