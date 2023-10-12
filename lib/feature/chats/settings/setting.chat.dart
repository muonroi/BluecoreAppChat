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
import 'package:url_launcher/url_launcher.dart';

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
          L(context, LanguageCodes.notificationTextInfo.toString()),
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
                L(context, LanguageCodes.isNotSureTextInfo.toString()),
                style: FontsGlobal.h6,
              )),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              actionName ?? L(context, LanguageCodes.isSureTextInfo.toString()),
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

List<Widget> menuWidget(BuildContext context, String text) {
  List<Widget> contentMenu = [
    IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorsGlobal.mainColor,
              content: SizedBox(
                  width: getPercentageOfDevice(context, expectWidth: 50).width,
                  child: const Text('Copied')),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.copy)),
  ];
  final detectTable = RegExp(
    r'\|(?:([^\r\n|]*)\|)+\r?\n\|(?:(:?-+:?)\|)+\r?\n(\|(?:([^\r\n|]*)\|)+\r?\n)+',
    multiLine: true,
  );
  final detectLink = RegExp(r'\[.*\]\((.*)\)');
  if (detectTable.hasMatch(text)) {
    contentMenu.add(IconButton(
        onPressed: () {
          prePreviewTable(context, text);
        },
        icon: const Icon(Icons.preview)));
  }
  if (detectLink.hasMatch(text)) {
    contentMenu.add(IconButton(
      onPressed: () async {
        RegExp urlRegex = RegExp(
          r'https?://\S+',
          caseSensitive: false,
        );

        Match? match = urlRegex.firstMatch(text);

        if (match != null) {
          await launchUrl(Uri.parse(match[0]!));
        }
      },
      icon: const Icon(Icons.download_outlined),
    ));
  }
  return contentMenu;
}

void prePreviewTable(BuildContext context, String text) {
  var scrollAxis =
      calculateTableWidth(context, text) > MediaQuery.of(context).size.width;
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
          body: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    L(context, LanguageCodes.copiedTextInfo.toString()),
                    style: FontsGlobal.h5,
                  ),
                ),
              );
            },
            child: SingleChildScrollView(
                scrollDirection: scrollAxis ? Axis.horizontal : Axis.vertical,
                child: SizedBox(
                  width: 5000,
                  child: MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      textScaleFactor: 0.8,
                    ),
                  ),
                )),
          ),
        );
      });
}

double calculateTableWidth(BuildContext context, String markdown) {
  final detectTable = RegExp(
    r'\|(?:([^\r\n|]*)\|)+\r?\n\|(?:(:?-+:?)\|)+\r?\n(\|(?:([^\r\n|]*)\|)+\r?\n)+',
    multiLine: true,
  );
  Match? match = detectTable.firstMatch(markdown);
  final List<String> rows = match![0].toString().trim().split('\n');
  final List<String> columns = rows[0].split('|').map((e) => e.trim()).toList();
  final int numColumns = columns.length;
  final double columnWidth =
      getPercentageOfDevice(context, expectWidth: 20).width ?? 0;
  return numColumns * columnWidth;
}

void showInfoSnackBar(BuildContext context, String message, bool isSuccess) {
  showTopSnackBar(
      Overlay.of(context),
      isSuccess
          ? CustomSnackBar.success(
              message: message,
            )
          : CustomSnackBar.error(
              message: message,
            ));
}
