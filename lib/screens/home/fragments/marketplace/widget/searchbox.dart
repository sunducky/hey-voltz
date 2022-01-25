import 'package:flutter/material.dart';
import 'package:hey_voltz/values/colors.dart';

class SearchBox extends StatelessWidget {
  SearchBox({
    Key? key,
    required this.deviceWidth,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  final double deviceWidth;
  TextEditingController controller;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: deviceWidth,
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        border: Border.all(color: colorTextfieldBorder, width: 0.6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Icon(
          //   Icons.search_rounded,
          //   color: colorTextfieldBorder,
          //   size: 20,
          // ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search here',
                border: InputBorder.none,
              ),
              controller: controller,
              onEditingComplete: () => onTap(),
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
          ),
          GestureDetector(
            onTap: () => onTap(),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: Center(
                  child: Icon(Icons.search_rounded, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
