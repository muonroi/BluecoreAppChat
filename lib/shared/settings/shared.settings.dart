import 'package:bluecore/core/localization/core.language.dart';
import 'package:bluecore/core/localization/core.localization.dart';
import 'package:bluecore/feature/accounts/data/models/model.token.dart';
import 'package:bluecore/feature/chats/provider/provider.chat.dart';
import 'package:bluecore/shared/models/device.dart';
import 'package:bluecore/shared/settings/shared.settings.base.url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

enum KeyToken { accessToken, refreshToken, encToken }

String L(BuildContext context, String key, {String locate = Languages.vi}) {
  ChatProvider chooseLanguage = ChatProvider();
  if (context.mounted) {
    chooseLanguage = context.watch<ChatProvider>();
  }
  return LocalizationLib.L(key,
      locale: chooseLanguage.language == Languages.none
          ? locate
          : chooseLanguage.language);
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
  String? token;
  String? refreshTokenStr;
  final sharedPreferences = await SharedPreferences.getInstance();
  token = sharedPreferences.getString(KeyToken.accessToken.name);
  var dio = Dio();
  dio.options.baseUrl = BaseApi.baseApi;
  dio.options.responseType = ResponseType.plain;
  // dio.interceptors.add(LogInterceptor());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        if (token != null && refreshTokenStr != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(request);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          token = sharedPreferences.getString(KeyToken.accessToken.name);
          refreshTokenStr =
              sharedPreferences.getString(KeyToken.refreshToken.name);
          try {
            await dio
                .post(sprintf(BaseApi.renewToken, [refreshTokenStr]))
                .then((value) async {
              if (value.statusCode == 200) {
                var newToken = tokenModelFromJson(value.data.toString());
                sharedPreferences.setString(
                    KeyToken.accessToken.name, newToken.result.accessToken);
                sharedPreferences.setString(
                    KeyToken.refreshToken.name, refreshTokenStr!);
                sharedPreferences.setString(KeyToken.encToken.name,
                    newToken.result.encryptedAccessToken);
                token = newToken.result.accessToken;
                e.requestOptions.headers["Authorization"] =
                    "Bearer ${newToken.result}";
                final opts = Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers);
                final cloneReq = await dio.request(e.requestOptions.path,
                    options: opts, data: e.requestOptions.data);
                return handler.resolve(cloneReq);
              }
            });
          } catch (e) {
            return;
          }
        }
      },
    ),
  );
  return dio;
}
