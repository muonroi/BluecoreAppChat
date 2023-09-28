import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final Color? color;
  const DividerWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <Widget>[Divider(color: color)],
      ),
    );
  }
}
