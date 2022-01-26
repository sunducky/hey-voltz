import 'package:flutter/material.dart';
import 'package:hey_voltz/screens/auth/components/textfield.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/appbar.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/btm_bar.dart';
import 'package:hey_voltz/values/colors.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int deliveryIndex = 0;

  var prices = [
    500.0,
    1500.0,
    2500.0,
  ];

  //States
  int flag = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          title: 'Checkout', showBackButton: true, showCartButton: false),
      bottomNavigationBar: BottomBar(
          shippingFee: prices[deliveryIndex],
          total: 2301.32,
          onBtnPressed: () {}),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTabSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InputField(
                          label: 'Full Name',
                          textInputType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InputField(
                          label: 'Phone Number',
                          textInputType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InputField(
                          label: 'Address',
                          textInputType: TextInputType.name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InputField(
                          label: 'State',
                          textInputType: TextInputType.name,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 20, vertical: 10),
                      //   child: InputField(
                      //     label: 'Country',
                      //     textInputType: TextInputType.name,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delivery',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          buildDeliveryCard(
                            id: 0,
                            name: 'Standard',
                            price: 500,
                          ),
                          const SizedBox(width: 10),
                          buildDeliveryCard(
                            id: 1,
                            name: 'Express',
                            price: 1500,
                          ),
                          const SizedBox(width: 10),
                          buildDeliveryCard(
                            id: 2,
                            name: 'Next day',
                            price: 2500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildDeliveryCard({
    required int id,
    required String name,
    required var price,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            deliveryIndex = id;
          });
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    (id == deliveryIndex) ? colorAccent : colorTextfieldBorder,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '₦$price',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: (id == deliveryIndex)
                      ? colorAccent
                      : colorTextfieldBorder,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: (id == deliveryIndex)
                      ? colorAccent
                      : colorTextfieldBorder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTabSection() {
    return Material(
      elevation: 6,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: (flag >= 1) ? colorPrimary : Colors.white,
                child: Center(
                  child: Text(
                    'Shipping',
                    style: TextStyle(
                      color: (flag >= 1) ? Colors.white : colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: (flag >= 2) ? colorPrimary : Colors.white,
                child: Center(
                  child: Text(
                    'Confirmation',
                    style: TextStyle(
                      color: (flag >= 2) ? Colors.white : colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
