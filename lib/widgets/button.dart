import 'package:flutter/material.dart';
import 'package:hey_voltz/values/colors.dart';

class ButtonPrimary extends StatefulWidget {
  ButtonPrimary({
    Key? key,
    required this.label,
    required this.onTap,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  String label;
  double? width;
  Function() onTap;
  bool isLoading;

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 45,
      width: widget.width ?? deviceWidth,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorPrimary,
      ),
      child: InkWell(
        onTap: (widget.isLoading) ? () {} : widget.onTap,
        child: Center(
          child: (widget.isLoading)
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
