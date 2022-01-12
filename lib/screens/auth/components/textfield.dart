import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  InputField({
    Key? key,
    required this.label,
    required this.textInputType,
    this.controller,
    this.isPassword = false,
  }) : super(key: key);

  String label;
  TextInputType textInputType;
  TextEditingController? controller;
  bool isPassword;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFDFDFDF),
      ),
      child: TextField(
        keyboardType: widget.textInputType,
        controller: widget.controller,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.label,
        ),
      ),
    );
  }
}
