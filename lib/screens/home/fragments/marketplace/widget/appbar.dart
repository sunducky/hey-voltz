import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_voltz/values/colors.dart';

buildAppBarForMarketplace(var deviceWidth) {
  return Material(
    color: colorPrimary,
    elevation: 4,
    child: Container(
      width: deviceWidth,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          const Align(
              alignment: Alignment.center,
              child: Text(
                'Voltz Store',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                splashRadius: 25,
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    ),
  );
}

buildAppBar(
  BuildContext context, {
  showCartButton = true,
  showBackButton = false,
}) {
  return AppBar(
    backgroundColor: colorPrimary,
    toolbarHeight: 80,
    leading: (showBackButton)
        ? IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left_rounded,
            ),
          )
        : const SizedBox(),
    title: const Text(
      'Voltz Store',
      style: TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    centerTitle: true,
    actions: [
      (showCartButton)
          ? IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
              ))
          : const SizedBox(),
      const SizedBox(width: 20)
    ],
  );
}
