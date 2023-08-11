// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {super.key,
      required this.hint,
      required this.controller,
      this.type = TextInputType.text,
      this.obscureText = false});
  String hint;
  TextInputType type;
  TextEditingController controller;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      obscureText: obscureText,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
      ),
    );
  }
}
