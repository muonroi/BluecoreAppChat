import 'package:bluecore/core/localization/core.language_code.dart';
import 'package:bluecore/feature/chats/presentation/widgets/widget.markdown.dart';
import 'package:bluecore/shared/settings/shared.settings.color.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:bluecore/shared/settings/shared.settings.font.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

int getMonthAgo(DateTime dateTime) {
  DateTime currentDate = DateTime.now();

  int yearsDiff = currentDate.year - dateTime.year;
  int monthsDiff = currentDate.month - dateTime.month;

  return (yearsDiff * 12) + monthsDiff;
}

Future<bool?> showConfirmationDialog(
    BuildContext context, String notification, String? actionName) async {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          L(LanguageCodes.notificationTextInfo.toString()),
          style: FontsGlobal.h4,
        ),
        content: Text(
          notification,
          style: FontsGlobal.h6,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                L(LanguageCodes.isNotSureTextInfo.toString()),
                style: FontsGlobal.h6,
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              actionName ?? L(LanguageCodes.isSureTextInfo.toString()),
              style: FontsGlobal.h6,
            ),
          ),
        ],
      );
    },
  );
}

Widget renderMarkdownWidget({required String pattern, required String text}) {
  return MarkDownWidget(
    child: text,
  );
}

void prePreviewTable(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: (builder) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
              color: ColorsGlobal.textColor,
            ),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied!'),
                  ),
                );
              },
              child: SizedBox(
                  child: MarkdownBody(
                data: text,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  textScaleFactor: 0.8,
                ),
              )),
            ),
          ),
        );
      });
}

void showInfoSnackBar(BuildContext context, String message) {
  showTopSnackBar(
      Overlay.of(context),
      message.contains("reconnected")
          ? const CustomSnackBar.success(
              message: "connected!",
            )
          : message.contains("reconnecting...")
              ? CustomSnackBar.info(
                  message: message,
                )
              : CustomSnackBar.error(
                  message: message,
                ));
}
