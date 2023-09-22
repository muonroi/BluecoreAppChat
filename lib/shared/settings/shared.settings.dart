import 'package:bluecore_appchat/core/localization/core.language.dart';
import 'package:bluecore_appchat/core/localization/core.localization.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.base.url.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum KeyToken { accessToken }

String L(String key, {String locate = Languages.vi}) {
  return LocalizationLib.L(key, locale: locate);
}

Future<Dio> getBaseUrl() async {
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
