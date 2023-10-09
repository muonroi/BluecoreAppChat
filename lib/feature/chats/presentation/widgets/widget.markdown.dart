import 'package:bluecore/shared/settings/shared.settings.font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkDownWidget extends StatelessWidget {
  final String child;

  const MarkDownWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: child,
      onTapLink: (text, href, title) async {
        if (await canLaunchUrl(Uri.parse(href!))) {
          await launchUrl(Uri.parse(href));
        }
      },
      onTapText: () {
        debugPrint('aa');
      },
      styleSheet: MarkdownStyleSheet(
          textScaleFactor: 1,
          a: FontsGlobal.h5.copyWith(decoration: TextDecoration.underline)),
    );
  }
}
