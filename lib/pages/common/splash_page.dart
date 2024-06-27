import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    debugPrint('inside redirect!');
    final session = supabase.auth.currentSession;
    if (!mounted) return;
    if (session != null) {
      if (supabase.auth.currentUser!.email!.contains("caias.in")) {
        Get.offAndToNamed("/widget_tree");
      } else {
        Get.offAndToNamed("/vwidget_tree");
      }
    } else {
      Get.offAndToNamed("/loginas");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              mainLogoMark(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Made by Hari Prasad'),
              ),
            ]),
      ),
    );
  }
}
