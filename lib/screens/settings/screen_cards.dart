import 'package:flutter/material.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/auth/components/textfield.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/button.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundAmountScreen extends StatefulWidget {
  FundAmountScreen({Key? key}) : super(key: key);

  @override
  FundAmountScreenState createState() => FundAmountScreenState();
}

class FundAmountScreenState extends State<FundAmountScreen> {
  final _amountController = TextEditingController();

  //States
  bool isApiLoading = false;

  //Prefs
  User? prefs;
  String? token;
  var pos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            color: colorPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 25,
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                    )),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Fund Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InputField(
              label: 'Amount',
              controller: _amountController,
              textInputType: TextInputType.number,
              isPassword: false,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonPrimary(
              label: 'Fund wallet',
              isLoading: isApiLoading,
              onTap: () => startPayment(),
            ),
          ),
        ],
      )),
    );
  }

  startPayment() async {
    prefs ??= await fetchUserData();
    token ??= await fetchPersistedToken();
    pos ??= await fetchPersistedLatLng();

    int amount = int.parse(_amountController.text);

    if (amount < 500) {
      Toasty(context).showToastErrorMessage(
          message: 'Amount to fund must be more than 500 naira');
      return;
    }

    final charge = Charge()
      ..email = prefs!.email
      ..amount = amount * 100 //convert to naira
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}';

    await PaystackClient.checkout(context, charge: charge, fullscreen: true)
        .then((res) {
      if (res.status) {
        doApiCall(
          ref: res.reference!,
          amount: charge.amount,
        );
      } else {
        Toasty(context)
            .showToastErrorMessage(message: 'Error completing transaction');
      }
    }).catchError((err) {
      print('Error paying paystack -> ' + err.runtimeType.toString());
    });
  }

  doApiCall({required String ref, required int amount}) async {
    setState(() {
      isApiLoading = true;
    });

    var body = {'reference': ref, 'amount': amount};

    await Provider.of<ApiService>(context, listen: false)
        .fundWallet(token!, body)
        .then((response) async {
      setState(() {
        isApiLoading = false;
      });
      if (response.isSuccessful) {
        prefs!.walletBalance =
            (prefs!.walletBalance! + amount / 100).toDouble();

        await persistUserData(prefs!);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                    latitude: pos['latitude'], longitude: pos['longitude'])),
            (route) => false);
      } else {
        //ignore:avoid_print
        print(response.statusCode);
        Toasty(context).showToastErrorMessage(
            message:
                'Could not register payment on server. You will be refunded in a few minutes.');
      }
    }).catchError((err) {
      setState(() {
        isApiLoading = false;
      });
      //ignore:avoid_print
      print('Payment api error -> ' + err.runtimeType.toString());
      Toasty(context).showToastErrorMessage(
          message: 'Something went wrong. contact developer!');
    });
  }
}
