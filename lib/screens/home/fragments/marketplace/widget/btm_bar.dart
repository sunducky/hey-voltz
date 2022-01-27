import 'package:flutter/material.dart';
import 'package:hey_voltz/widgets/button.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    Key? key,
    required this.total,
    this.shippingFee = 0.0,
    required this.onBtnPressed,
  }) : super(key: key);

  double total;
  double shippingFee;
  Function() onBtnPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.white,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (shippingFee > 0)
                    ? Text(
                        '₦${total.toStringAsFixed(2)} + Shipping: ₦${shippingFee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      )
                    : const SizedBox(),
                Text(
                  'Total: ₦${(total + shippingFee).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            (total < 1.0)
                ? const SizedBox()
                : ButtonPrimary(
                    label: 'Continue',
                    width: 100,
                    onTap: () => onBtnPressed(),
                  ),
          ],
        ),
      ),
    );
  }
}
