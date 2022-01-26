import 'package:flutter/material.dart';
import 'package:hey_voltz/screens/home/fragments/marketplace/widget/appbar.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/button.dart';

import 'widget/cart_item.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: buildAppBar(context,
          showBackButton: true, showCartButton: false, title: 'My Cart'),
      bottomNavigationBar: Material(
        elevation: 5,
        color: Colors.white,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Total: ₦3000.12',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ButtonPrimary(
                label: 'Checkout',
                width: 100,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CartItem(
                  itemID: 1,
                  itemName: 'Product One',
                  itemPrice: 210.99,
                  quantity: 1,
                  itemImage: 'wee',
                ),
                CartItem(
                  itemID: 1,
                  itemName: 'Product One',
                  itemPrice: 210.99,
                  quantity: 1,
                  itemImage: 'wee',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
