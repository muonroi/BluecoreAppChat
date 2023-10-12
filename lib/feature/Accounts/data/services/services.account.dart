import 'package:bluecore/feature/accounts/data/models/model.authenticate.dart';
import 'package:bluecore/shared/models/model.baseoutput.dart';
import 'package:bluecore/shared/settings/shared.settings.base.url.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:dio/dio.dart';

class ServiceAccount {
  Future<AuthenticateModel> signIn(String username, String password) async {
    try {
      Map<String, dynamic> data = {
        "tenantId": null,
        'userNameOrEmailAddress': username,
        'password': password,
        "rememberClient": false,
        "singleSignIn": false,
        "returnUrl": null,
        "captchaResponse": null
      };
      final Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'ContentType': 'application/json'
      };
      var dio = Dio(BaseOptions(
          baseUrl: BaseApi.baseApi,
          responseType: ResponseType.plain,
          headers: headers));
      final response = await dio.post(
        BaseApi.authenticate,
        data: data,
      );
      if (response.statusCode == 200) {
        return authenticateFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return AuthenticateModel(
            result: null,
            targetUrl: null,
            success: false,
            error: null,
            unAuthorizedRequest: null,
            abp: null);
      }
    }
    return AuthenticateModel(
        result: null,
        targetUrl: null,
        success: false,
        error: null,
        unAuthorizedRequest: null,
        abp: null);
  }

  Future<BaseOutputModel> forgotPassword(String username) async {
    try {
      Map<String, dynamic> data = {
        'emailAddress': username,
      };
      final Map<String, dynamic> headers = {
        'Accept': 'application/json',
        'ContentType': 'application/json'
      };
      var dio = Dio(BaseOptions(
          baseUrl: BaseApi.baseApi,
          responseType: ResponseType.plain,
          headers: headers));
      final response = await dio.post(
        BaseApi.sendPassword,
        data: data,
      );
      if (response.statusCode == 200) {
        return baseOutputFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return BaseOutputModel(
          result: null,
          targetUrl: null,
          success: false,
          error: null,
          unAuthorizedRequest: false,
          abp: false,
        );
      }
    }
    return BaseOutputModel(
      result: null,
      targetUrl: null,
      success: false,
      error: null,
      unAuthorizedRequest: false,
      abp: false,
    );
  }

  Future<BaseOutputModel> changeLanguage(String code) async {
    try {
      Map<String, dynamic> data = {
        "languageName": code,
      };
      var dio = await getBaseApi();
      final response = await dio.post(
        BaseApi.changeLanguage,
        data: data,
      );
      if (response.statusCode == 200) {
        return baseOutputFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return BaseOutputModel(
          result: null,
          targetUrl: null,
          success: false,
          error: null,
          unAuthorizedRequest: false,
          abp: false,
        );
      }
    }
    return BaseOutputModel(
      result: null,
      targetUrl: null,
      success: false,
      error: null,
      unAuthorizedRequest: false,
      abp: false,
    );
  }
}
