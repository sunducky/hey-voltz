import 'package:flutter/material.dart';
import 'package:hey_voltz/sqlite/cart_provider.dart';
import 'package:hey_voltz/sqlite/models.dart' as m;
import 'package:hey_voltz/values/colors.dart';

class CartItem extends StatefulWidget {
  CartItem({
    Key? key,
    required this.itemID,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.itemStock,
    required this.quantity,
    required this.onDeleteTap,
    required this.onQtyChanged,
  }) : super(key: key);

  int itemID;
  int itemStock;
  String itemName;
  double itemPrice;
  String itemImage;
  int quantity;
  Function() onDeleteTap;
  VoidCallback onQtyChanged;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
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
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: widget.onDeleteTap,
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (widget.quantity > 1)
                        ? GestureDetector(
                            onTap: () => decreaseQty(),
                            child: const Icon(
                              Icons.remove_rounded,
                              color: colorAccentTwo,
                              size: 25,
                            ),
                          )
                        : const SizedBox(width: 25),
                    Text('${widget.quantity}',
                        style: const TextStyle(fontSize: 16)),
                    (widget.quantity >= widget.itemStock)
                        ? const SizedBox(width: 25)
                        : GestureDetector(
                            onTap: () => increaseQty(),
                            child: const Icon(
                              Icons.add_rounded,
                              color: colorAccentTwo,
                              size: 25,
                            ),
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

  decreaseQty() async {
    widget.quantity -= 1;
    m.CartItem cartItem = m.CartItem(
        id: widget.itemID,
        quantity: widget.quantity,
        stock: widget.itemStock,
        image: widget.itemImage,
        name: widget.itemName,
        price: widget.itemPrice);
    await CartProvider().updateCartItem(cartItem).then((isSuccessful) {
      if (isSuccessful) {
        setState(() {
          //happy
        });
        widget.onQtyChanged();
      } else {
        //Revert value back to normal
        widget.quantity += 1;
      }
    }).catchError((err) {
      widget.quantity += 1;
      print('CartItem err -> ' + err.runtimeType.toString());
    });
  }

  increaseQty() async {
    if (widget.quantity == widget.itemStock) {
      return;
    }
    widget.quantity += 1;
    m.CartItem cartItem = m.CartItem(
        id: widget.itemID,
        quantity: widget.quantity,
        image: widget.itemImage,
        stock: widget.itemStock,
        name: widget.itemName,
        price: widget.itemPrice);
    await CartProvider().updateCartItem(cartItem).then((isSuccessful) {
      if (isSuccessful) {
        widget.onQtyChanged();
        setState(() {
          //happy
        });
      } else {
        //Revert value back to normal
        widget.quantity -= 1;
      }
    }).catchError((err) {
      widget.quantity -= 1;
      print('CartItem err -> ' + err.runtimeType.toString());
    });
  }
}
