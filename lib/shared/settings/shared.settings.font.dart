import 'package:flutter/material.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.color.dart';

class FontsGlobal {
  static List<String> getFontsNameAvailable() => [inter];
  //Fonts setting
  static const String inter = 'Inter';

  //Text style setting
  static TextStyle h1 = const TextStyle(
      fontFamily: inter, fontSize: 90.66, color: ColorsGlobal.textColor);
  static TextStyle h2 = const TextStyle(
      fontFamily: inter, fontSize: 50.77, color: ColorsGlobal.textColor);
  static TextStyle h3 = const TextStyle(
      fontFamily: inter, fontSize: 30.89, color: ColorsGlobal.textColor);
  static TextStyle h4 = const TextStyle(
      fontFamily: inter, fontSize: 20.89, color: ColorsGlobal.textColor);
  static TextStyle h5 = const TextStyle(
      fontFamily: inter, fontSize: 16, color: ColorsGlobal.textColor);
  static TextStyle h6 = const TextStyle(
      fontFamily: inter, fontSize: 11.89, color: ColorsGlobal.textColor);
}
