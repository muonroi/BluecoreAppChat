import 'package:bluecore/core/localization/core.language.dart';
import 'package:bluecore/feature/chats/settings/enums/cache.enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  String _languageCurrent = Languages.vi;
  ChatProvider() {
    _loadLanguage();
  }
  Future<void> _loadLanguage() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (_languageCurrent == Languages.none) {
      _languageCurrent =
          sharedPreferences.getString(CacheChatEnum.currentLanguage.name) ??
              Languages.vi;
    }
    notifyListeners();
  }

  String get language => _languageCurrent;
  set changeLanguage(String code) {
    _languageCurrent = code;
    notifyListeners();
  }
}
