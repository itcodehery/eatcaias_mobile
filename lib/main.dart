import 'package:Eat.Caias/pages/studteach/home.dart';
import 'package:Eat.Caias/pages/studteach/studlogin.dart';
import 'package:Eat.Caias/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseKey = String.fromEnvironment("PROJ_API_KEY");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize dotenv
  await dotenv.load(fileName: ".env");
  // initialize supabase
  await Supabase.initialize(
    url: dotenv.env["PROJ_URL"]!,
    anonKey: dotenv.env["PROJ_API_KEY"]!,
  );
  debugPrint(supabaseKey);
  runApp(const EatCAIAS());
}

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
      ),
      home: const Studlogin(),
      routes: {
        "/home": (context) => const Home(),
        "/login": (context) => const Studlogin(),
        "/widget_tree": (context) => const WidgetTree(),
      },
    );
  }
}
