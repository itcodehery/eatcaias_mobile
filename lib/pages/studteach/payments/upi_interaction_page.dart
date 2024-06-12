import 'package:flutter/material.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';

class UpiInteractionPage extends StatefulWidget {
  const UpiInteractionPage({
    Key? key,
    required this.shopName,
    required this.totalPrice,
  }) : super(key: key);

  final String shopName;
  final int totalPrice;

  @override
  _UpiInteractionPageState createState() => _UpiInteractionPageState();
}

class _UpiInteractionPageState extends State<UpiInteractionPage> {
  late List<ApplicationMeta> appMetaList = [];
  @override
  void initState() {
    super.initState();
    getApps();
  }

  Future<void> getApps() async {
    appMetaList = await UpiPay.getInstalledUpiApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select your UPI App'),
        ),
        body: appMetaList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: appMetaList.length,
                itemBuilder: (context, index) {
                  return appWidget(appMetaList[index]);
                },
              ));
  }

  Widget appWidget(ApplicationMeta appMeta) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        appMeta.iconImage(48), // Logo
        Container(
          margin: const EdgeInsets.only(top: 4),
          alignment: Alignment.center,
          child: Text(
            appMeta.upiApplication.appName,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
