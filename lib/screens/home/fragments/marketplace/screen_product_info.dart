import 'package:flutter/material.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/values/colors.dart';

import 'widget/appbar.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  Product product;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(context, showCartButton: true, showBackButton: true),
      body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: deviceWidth,
          height: deviceHeight / 3,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.product.images[0].url),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      widget.product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.categories[0].name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₦${widget.product.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text('Quantity:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(width: 15),
              (quantity > 1)
                  ? qtyBtn(
                      icon: Icons.remove_rounded,
                      onTap: () {
                        setState(() {
                          quantity--;
                        });
                      })
                  : const SizedBox(width: 30),
              const SizedBox(width: 15),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 15),
              qtyBtn(
                  icon: Icons.add_rounded,
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  }),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Add to cart',
                    style: TextStyle(
                      color: colorAccent,
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: colorTextfieldBorder,
          thickness: 1,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(widget.product.description,
                  style: const TextStyle(
                    fontSize: 15,
                  )),
            ],
          ),
        ),
        const Divider(
          color: colorTextfieldBorder,
          thickness: 1,
        ),
        const SizedBox(height: 20),
      ])),
    );
  }

  GestureDetector qtyBtn({required Function onTap, required IconData icon}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          border: Border.all(color: colorTextfieldBorder, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(
          icon,
          size: 24,
          color: colorTextfieldBorder,
        ),
      ),
    );
  }
}