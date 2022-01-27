import 'package:flutter/material.dart';
import 'package:hey_voltz/sqlite/models.dart' as wee;
import 'package:hey_voltz/screens/home/fragments/marketplace/screen_checkout.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/appbar.dart';
import 'package:hey_voltz/sqlite/cart_provider.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/button.dart';

import 'widget/btm_bar.dart';
import 'widget/cart_item.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<wee.CartItem> cartItems = [];
  double cartTotal = 0.0;

  //States
  bool flag = false;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  fetchCart() async {
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
    var deviceWidth = MediaQuery.of(context).size.width;

    if (!flag) {
      return const Scaffold(
        body: SafeArea(
            child: Center(
          child: CircularProgressIndicator(),
        )),
      );
    }
    return Scaffold(
      appBar: buildAppBar(context,
          showBackButton: true, showCartButton: false, title: 'My Cart'),
      bottomNavigationBar: BottomBar(
        total: cartTotal,
        onBtnPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => CheckoutScreen())),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: (cartItems.isEmpty)
                ? Center(
                    child: Text(
                        'There are no items in your cart. Please add some items to proceed'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      wee.CartItem item = cartItems[index];
                      return CartItem(
                          itemID: item.id,
                          itemName: item.name,
                          itemImage: item.image,
                          itemPrice: item.price,
                          quantity: item.quantity);
                    }),
          ),
        ),
      ),
    );
  }
}
