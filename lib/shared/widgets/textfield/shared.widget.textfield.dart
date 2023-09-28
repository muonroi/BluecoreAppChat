import 'package:flutter/material.dart';

class TextFormFieldGlobal extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final InputDecoration? decoration;
  const TextFormFieldGlobal(
      {super.key, this.controller, required this.obscureText, this.decoration});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      obscureText: obscureText,
      decoration: decoration,
    );
  }
}
