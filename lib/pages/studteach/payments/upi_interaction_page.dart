import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:ticket_widget/ticket_widget.dart';

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
  String upiID = "haririo321@oksbi";
  String upiName = 'Hari';
  // List<ApplicationMeta>? appMetaList;

  @override
  void initState() {
    _fetchVendorDetails();
    super.initState();
  }

  Future<void> _fetchUPIApps() async {}

  Future<void> _fetchVendorDetails() async {
    try {
      final response = await supabase
          .from('vendor_user')
          .select()
          .eq('shop_name', widget.shopName)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          upiID = (response['upi_id'] ?? "haririo321@oksbi") as String;
          upiName = (response['upi_name'] ?? "Hari") as String;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(normalSnackBar("UPI ID: $upiID\nUPI Name: $upiName"));
        debugPrint("UPI ID: $upiID");
        debugPrint("UPI Name: $upiName");
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(normalSnackBar("No Vendor UPI ID Found!"));
        }
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Future<void> doUpiTransaction() async {
    try {
      debugPrint("inside transaction");
      final res = await EasyUpiPaymentPlatform.instance.startPayment(
        EasyUpiPaymentModel(
          payeeVpa: upiID,
          payeeName: upiName,
          amount: widget.totalPrice.toDouble(),
          description: 'Eat.CAIAS to ${widget.shopName}',
        ),
      );
      // TODO: add your success logic here
      debugPrint(res != null ? res.responseCode : "Unknown error occured!");
    } on EasyUpiPaymentException catch (e) {
      // TODO: add your exception logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Bill Payment'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.amber,
              Colors.orange,
            ])),
        child: Center(
          child: TicketWidget(
            isCornerRounded: true,
            width: 320,
            //add animation
            height: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: mainLogoMark(),
                    trailing: const Icon(Icons.verified_outlined),
                  ),
                  ListTile(
                    title: Text('${widget.shopName} bill'),
                    subtitle: const Text("Paying through UPI"),
                    trailing: Text("₹${widget.totalPrice}.00",
                        style: headerTextStyle),
                  ),
                  ListTile(
                    title: const Text('Convenience Tax (10%)'),
                    trailing: Text(
                      '+ ₹${widget.totalPrice / 10}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black12,
                  ),
                  ListTile(
                    title: const Text('UPI ID'),
                    subtitle: Text(upiID),
                  ),
                  ListTile(
                    title: const Text('UPI Name'),
                    subtitle: Text(upiName),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Total: ₹${widget.totalPrice + widget.totalPrice / 10}',
                    style: headerTextStyle),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.amber.shade400,
                      Colors.orange.shade400,
                    ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade900.withOpacity(0.2),
                        spreadRadius: 0.2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      //gradient background
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Start Transaction',
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
