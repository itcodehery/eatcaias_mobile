import 'package:flutter/material.dart';

class FourOFour extends StatelessWidget {
  const FourOFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1000)),
            image: DecorationImage(
                image: NetworkImage(
                    "https://th.bing.com/th/id/OIG1.raljIHL0dUZF.hmZiJEp?w=1024&h=1024&rs=1&pid=ImgDetMain"),
                fit: BoxFit.cover)),
      )),
    );
  }
}
