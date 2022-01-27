import 'package:flutter/material.dart';
import 'package:hey_voltz/sqlite/cart_provider.dart';
import 'package:hey_voltz/sqlite/models.dart' as m;
import 'package:hey_voltz/values/colors.dart';

class CheckoutItem extends StatefulWidget {
  CheckoutItem({
    Key? key,
    required this.itemID,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.quantity,
  }) : super(key: key);

  int itemID;
  String itemName;
  double itemPrice;
  String itemImage;
  int quantity;

  @override
  State<CheckoutItem> createState() => _CheckoutItemState();
}

class _CheckoutItemState extends State<CheckoutItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: colorAccentTwo,
              image: DecorationImage(
                image: NetworkImage(widget.itemImage),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.itemName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₦${widget.itemPrice}',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
              '${widget.quantity}\n${(widget.quantity * widget.itemPrice).toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
