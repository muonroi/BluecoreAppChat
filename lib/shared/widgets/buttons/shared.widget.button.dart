import 'package:flutter/material.dart';

class ButtonGlobal extends StatefulWidget {
  const ButtonGlobal(
      {super.key,
      required this.style,
      required this.text,
      required this.onPressed,
      required this.textStyle});
  final ButtonStyle style;
  final TextStyle textStyle;
  final String text;
  final void Function() onPressed;
  @override
  State<ButtonGlobal> createState() => _ButtonGlobalState();
}

class _ButtonGlobalState extends State<ButtonGlobal> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: widget.textStyle,
      ),
    );
  }
}
