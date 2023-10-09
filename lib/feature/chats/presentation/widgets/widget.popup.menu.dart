import 'package:flutter/material.dart';

class PopUpMenuTile extends StatelessWidget {
  const PopUpMenuTile(
      {super.key,
      required this.icon,
      required this.title,
      this.isActive = false});
  final IconData icon;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon,
            color: isActive
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isActive
                  ? Theme.of(context).cardColor
                  : Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
