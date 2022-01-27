import 'package:flutter/material.dart';
import 'package:hey_voltz/values/colors.dart';

class CartItem extends StatelessWidget {
  CartItem({
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: colorAccentTwo,
              image: DecorationImage(
                image: NetworkImage(itemImage),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₦$itemPrice',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.remove_rounded,
                      color: colorAccentTwo,
                      size: 25,
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16)),
                    const Icon(
                      Icons.add_rounded,
                      color: colorAccentTwo,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
