import 'dart:convert';

AuthenticateModel authenticateFromJson(String str) =>
    AuthenticateModel.fromJson(json.decode(str));

String authenticateToJson(AuthenticateModel data) => json.encode(data.toJson());

class AuthenticateModel {
  AuthenticateResult? result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? abp;

  AuthenticateModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory AuthenticateModel.fromJson(Map<String, dynamic> json) =>
      AuthenticateModel(
        result: AuthenticateResult.fromJson(json["result"]),
        targetUrl: json["targetUrl"],
        success: json["success"],
        error: json["error"],
        unAuthorizedRequest: json["unAuthorizedRequest"],
        abp: json["__abp"],
      );

  Map<String, dynamic> toJson() => {
        "result": result != null ? result!.toJson() : null,
        "targetUrl": targetUrl,
        "success": success,
        "error": error,
        "unAuthorizedRequest": unAuthorizedRequest,
        "__abp": abp,
      };
}

class AuthenticateResult {
  String accessToken;
  String encryptedAccessToken;
  int expireInSeconds;
  bool shouldResetPassword;
  dynamic passwordResetCode;
  int tenantId;
  int userId;
  bool requiresTwoFactorVerification;
  dynamic twoFactorAuthProviders;
  dynamic twoFactorRememberClientToken;
  dynamic returnUrl;
  String refreshToken;
  int refreshTokenExpireInSeconds;
  dynamic c;
  String metabaseSessionTokenForSystem;
  String metabaseSessionTokenForCookie;

  AuthenticateResult({
    required this.accessToken,
    required this.encryptedAccessToken,
    required this.expireInSeconds,
    required this.shouldResetPassword,
    required this.passwordResetCode,
    required this.tenantId,
    required this.userId,
    required this.requiresTwoFactorVerification,
    required this.twoFactorAuthProviders,
    required this.twoFactorRememberClientToken,
    required this.returnUrl,
    required this.refreshToken,
    required this.refreshTokenExpireInSeconds,
    required this.c,
    required this.metabaseSessionTokenForSystem,
    required this.metabaseSessionTokenForCookie,
  });

  factory AuthenticateResult.fromJson(Map<String, dynamic> json) =>
      AuthenticateResult(
        accessToken: json["accessToken"],
        encryptedAccessToken: json["encryptedAccessToken"],
        expireInSeconds: json["expireInSeconds"],
        shouldResetPassword: json["shouldResetPassword"],
        passwordResetCode: json["passwordResetCode"],
        tenantId: json["tenantId"],
        userId: json["userId"],
        requiresTwoFactorVerification: json["requiresTwoFactorVerification"],
        twoFactorAuthProviders: json["twoFactorAuthProviders"],
        twoFactorRememberClientToken: json["twoFactorRememberClientToken"],
        returnUrl: json["returnUrl"],
        refreshToken: json["refreshToken"],
        refreshTokenExpireInSeconds: json["refreshTokenExpireInSeconds"],
        c: json["c"],
        metabaseSessionTokenForSystem: json["metabaseSessionTokenForSystem"],
        metabaseSessionTokenForCookie: json["metabaseSessionTokenForCookie"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "encryptedAccessToken": encryptedAccessToken,
        "expireInSeconds": expireInSeconds,
        "shouldResetPassword": shouldResetPassword,
        "passwordResetCode": passwordResetCode,
        "tenantId": tenantId,
        "userId": userId,
        "requiresTwoFactorVerification": requiresTwoFactorVerification,
        "twoFactorAuthProviders": twoFactorAuthProviders,
        "twoFactorRememberClientToken": twoFactorRememberClientToken,
        "returnUrl": returnUrl,
        "refreshToken": refreshToken,
        "refreshTokenExpireInSeconds": refreshTokenExpireInSeconds,
        "c": c,
        "metabaseSessionTokenForSystem": metabaseSessionTokenForSystem,
        "metabaseSessionTokenForCookie": metabaseSessionTokenForCookie,
      };
}
