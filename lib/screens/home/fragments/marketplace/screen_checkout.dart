import 'package:flutter/material.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/auth/components/textfield.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/checkout_item.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/sqlite/cart_provider.dart';
import 'package:hey_voltz/sqlite/models.dart' as wee;
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/appbar.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/btm_bar.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late User user;
  late String token;

  int deliveryIndex = 0;

  var prices = [
    500.0,
    1500.0,
    2500.0,
  ];

  List<wee.CartItem> cartItems = [];
  double cartTotal = 0.0;

  //States
  bool flag = false;
  int tabIndex = 1;

  Key nameKey = const Key('one');

  //Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  //Values
  String name = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchCart();
  }

  fetchUser() async {
    user = await fetchUserData();
    token = await fetchPersistedToken();

    _nameController.text = user.firstname! + ' ' + user.lastname!;
    _phoneController.text = user.phone ?? '';
  }

  fetchCart() async {
    // setState(() {
    //   flag = false;
    // });
    await CartProvider().getCartItems().then((value) {
      cartItems = value;
      if (cartItems.isNotEmpty) {
        for (var item in cartItems) {
          cartTotal = cartTotal + (item.price * item.quantity);
        }
      }
      setState(() {
        //refreshes the screen.
        flag = true;
      });
    }).catchError((err) {
      print('CartScreen err -> ' + err.runtimeType.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!flag) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return Scaffold(
      appBar: buildAppBar(context,
          title: 'Checkout', showBackButton: true, showCartButton: false),
      bottomNavigationBar: BottomBar(
          // shippingFee: prices[deliveryIndex],
          total: cartTotal,
          onBtnPressed: () {
            if (tabIndex == 1) {
              name = _nameController.text.trim();
              phone = _phoneController.text.trim();
              address = _addressController.text.trim();

              if (name.isEmpty) {
                Toasty(context)
                    .showToastErrorMessage(message: 'Name cannot be empty');
                return;
              } else if (phone.isEmpty) {
                Toasty(context).showToastErrorMessage(
                    message: 'Phone number cannot be empty');
                return;
              } else if (address.isEmpty) {
                Toasty(context)
                    .showToastErrorMessage(message: 'Address cannot be empty');
                return;
              } else {
                setState(() {
                  tabIndex = 2;
                });
              }
            } else {
              placeOrder();
            }
          }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTabSection(),
            (tabIndex == 1)
                ? buildShippingInfoSection()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 60),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Shipping to',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$name \n$phone \n$address',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Your Order',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartItems.length,
                                  itemBuilder: (context, index) {
                                    wee.CartItem item = cartItems[index];
                                    return CheckoutItem(
                                        itemID: item.id,
                                        itemName: item.name,
                                        itemImage: item.image,
                                        itemPrice: item.price,
                                        quantity: item.quantity);
                                  }),
                            ),
                            const SizedBox(height: 20),
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

  Expanded buildShippingInfoSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shipping to',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InputField(
                  key: nameKey,
                  label: 'Full Name',
                  textInputType: TextInputType.name,
                  controller: _nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InputField(
                  label: 'Phone Number',
                  textInputType: TextInputType.phone,
                  controller: _phoneController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InputField(
                  label: 'Address',
                  textInputType: TextInputType.name,
                  controller: _addressController,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: InputField(
              //     label: 'State',
              //     textInputType: TextInputType.name,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 20, vertical: 10),
              //   child: InputField(
              //     label: 'Country',
              //     textInputType: TextInputType.name,
              //   ),
              // ),
              const SizedBox(height: 20),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Delivery',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              // Row(
              //   children: [
              //     buildDeliveryCard(
              //       id: 0,
              //       name: 'Standard',
              //       price: 500,
              //     ),
              //     const SizedBox(width: 10),
              //     buildDeliveryCard(
              //       id: 1,
              //       name: 'Express',
              //       price: 1500,
              //     ),
              //     const SizedBox(width: 10),
              //     buildDeliveryCard(
              //       id: 2,
              //       name: 'Next day',
              //       price: 2500,
              //     ),
              //   ],
              // ),
            ],
          ),
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
                color: (tabIndex >= 1) ? colorPrimary : Colors.white,
                child: Center(
                  child: Text(
                    'Shipping',
                    style: TextStyle(
                      color: (tabIndex >= 1) ? Colors.white : colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: (tabIndex >= 2) ? colorPrimary : Colors.white,
                child: Center(
                  child: Text(
                    'Confirmation',
                    style: TextStyle(
                      color: (tabIndex >= 2) ? Colors.white : colorPrimary,
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

  placeOrder() async {
    var items = [];

    for (var item in cartItems) {
      var c = {
        'id': item.id,
        'quantity': item.quantity,
      };
      items.add(c);
    }

    var body = {
      'products': items,
      'txRef': 'ref_${DateTime.now().millisecondsSinceEpoch}',
      'address': address,
      'phone': phone,
      'name': name
    };

    setState(() {
      flag = false;
    });

    await Provider.of<ApiService>(context, listen: false)
        .placeOrder(token, body)
        .then((response) async {
      if (response.isSuccessful) {
        Toasty(context).showToastSuccessMessage(
            message: 'Order has been placed successfully');
        user.walletBalance = user.walletBalance! - cartTotal;
        await persistUserData(user);
        var pos = await fetchPersistedLatLng();
        bool cleared = await CartProvider().clearCart();
        if (cleared) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => HomeScreen(
                        latitude: pos['latitude']!,
                        longitude: pos['longitude']!,
                        screenIndex: 0,
                      )),
              (route) => false);
        } else {
          Toasty(context).showToastMessage(message: 'Could not clear cart');
        }
      } else {
        Toasty(context).showToastErrorMessage(
            message: 'PlaceOrder serv -> ' +
                response.statusCode.toString() +
                '; - ' +
                response.bodyString);
        setState(() {
          flag = true;
        });
      }
    }).catchError((err) {
      setState(() {
        flag = true;
      });
      Toasty(context).showToastErrorMessage(
          message: 'PlaceOrder err --> ' + err.runtimeType.toString());
    });
  }
}
