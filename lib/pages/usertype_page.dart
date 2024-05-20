import 'package:flutter/material.dart';

class UsertypePage extends StatelessWidget {
  const UsertypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.amber.shade600),
        foregroundColor: MaterialStatePropertyAll(Colors.brown.shade700),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'eat.',
                    style: TextStyle(
                      color: Colors.brown.shade700,
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    'caias',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
              const Text('For your Canteen'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Login as'),
          ElevatedButton(
              style: buttonStyle,
              onPressed: () => Navigator.of(context).pushNamed("/vendorlogin"),
              child: const Text('Vendor')),
          ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              child: const Text('Student/Staff'))
        ],
      )),
    );
  }
}
