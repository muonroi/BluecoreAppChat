import 'package:bluecore/core/localization/core.language.dart';
import 'package:bluecore/core/localization/core.localization.dart';
import 'package:bluecore/shared/models/device.dart';
import 'package:bluecore/shared/settings/shared.settings.base.url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum KeyToken { accessToken, refreshToken, encToken }

String L(String key, {String locate = Languages.vi}) {
  return LocalizationLib.L(key, locale: locate);
}

SizeDeviceScreen getPercentageOfDevice(BuildContext context,
    {double expectHeight = 0.0, double expectWidth = 0.0}) {
  double baseWidth = MediaQuery.of(context).size.width;
  double baseHeight = MediaQuery.of(context).size.height;
  return SizeDeviceScreen(
      width: (((expectWidth / baseWidth) * 100) / 100) * baseWidth,
      height: (((expectHeight / baseHeight) * 100) / 100) * baseHeight);
}

Future<Dio> getBaseApi() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final token = sharedPreferences.getString(KeyToken.accessToken.name);
  if (token == null) {
    //login here
  }
  var dio = Dio();
  dio.options.baseUrl = BaseApi.baseApi;
  dio.options.responseType = ResponseType.plain;
  // dio.interceptors.add(LogInterceptor());
  dio.options.headers['Authorization'] = 'Bearer $token';
  return dio;
}
