import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  late List<Widget>? contents;
  ChatProvider({this.contents});
  set contentNew(Widget content) {
    contents!.add(content);
    notifyListeners();
  }
}
