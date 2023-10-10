// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  Result result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool unAuthorizedRequest;
  bool abp;

  TokenModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        result: Result.fromJson(json["result"]),
        targetUrl: json["targetUrl"],
        success: json["success"],
        error: json["error"],
        unAuthorizedRequest: json["unAuthorizedRequest"],
        abp: json["__abp"],
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "targetUrl": targetUrl,
        "success": success,
        "error": error,
        "unAuthorizedRequest": unAuthorizedRequest,
        "__abp": abp,
      };
}

class Result {
  String accessToken;
  String encryptedAccessToken;
  int expireInSeconds;

  Result({
    required this.accessToken,
    required this.encryptedAccessToken,
    required this.expireInSeconds,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        accessToken: json["accessToken"],
        encryptedAccessToken: json["encryptedAccessToken"],
        expireInSeconds: json["expireInSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "encryptedAccessToken": encryptedAccessToken,
        "expireInSeconds": expireInSeconds,
      };
}
