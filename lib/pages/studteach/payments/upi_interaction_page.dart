import 'package:eat_caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upi_india/upi_india.dart';

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
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  String upiID = "haririo321@oksbi";
  String upiName = 'Hari';

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      setState(() {
        apps = [];
        Get.showSnackbar(
            normalGetSnackBar("No Cash, Honey!", "No UPI apps found"));
      });
    });
    _fetchVendorDetails();
    super.initState();
  }

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

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: upiID,
      receiverName: upiName,
      transactionRefId: 'EatCaiasPayment',
      transactionNote: 'Eat.CAIAS to ${widget.shopName}',
      amount: widget.totalPrice.toDouble() + widget.totalPrice / 10,
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return const Center(
        child: Text(
          "No apps found to handle transaction.",
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return ListTile(
                onTap: () {
                  setState(() {
                    _transaction = initiateTransaction(app);
                  });
                },
                leading: Image.memory(
                  app.icon,
                  width: 40,
                ),
                title: Text(app.name),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        debugPrint('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        debugPrint('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        debugPrint('Transaction Failed');
        break;
      default:
        debugPrint('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: "),
          Flexible(
              child: Text(
            body,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your UPI App'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: displayUpiApps(),
        ),
        Expanded(
          child: FutureBuilder(
            future: _transaction,
            builder:
                (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  Get.showSnackbar(normalGetSnackBar(
                      "Oops!", _upiErrorHandler(snapshot.error.runtimeType)));
                  return const Center(
                    child: Text(""), // Print's text message on screen
                  );
                }

                // If we have data then definitely we will have UpiResponse.
                // It cannot be null
                UpiResponse upiResponse = snapshot.data!;

                // Data in UpiResponse can be null. Check before printing
                String txnId = upiResponse.transactionId ?? 'N/A';
                String resCode = upiResponse.responseCode ?? 'N/A';
                String txnRef = upiResponse.transactionRefId ?? 'N/A';
                String status = upiResponse.status ?? 'N/A';
                String approvalRef = upiResponse.approvalRefNo ?? 'N/A';
                _checkTxnStatus(status);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      displayTransactionData('Transaction Id', txnId),
                      displayTransactionData('Response Code', resCode),
                      displayTransactionData('Reference Id', txnRef),
                      displayTransactionData('Status', status.toUpperCase()),
                      displayTransactionData('Approval No', approvalRef),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(''),
                );
              }
            },
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Paying to ${widget.shopName}'),
                const Spacer(),
                Text("₹${widget.totalPrice}.00 + ${widget.totalPrice / 10} Tax",
                    style: headerTextStyle),
              ],
            )),
      ),
    );
  }
}
