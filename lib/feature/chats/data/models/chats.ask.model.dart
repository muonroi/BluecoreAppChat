import 'dart:convert';

import 'package:bluecore/core/localization/core.language_code.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';

AskChatModel askChatModelFromJson(String str) =>
    AskChatModel.fromJson(json.decode(str));

String askChatModelToJson(AskChatModel data) => json.encode(data.toJson());

class AskChatModel {
  AskChatResult? result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool unAuthorizedRequest;
  bool abp;

  AskChatModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory AskChatModel.fromJson(Map<String, dynamic> json) => AskChatModel(
        result: AskChatResult.fromJson(json["result"]),
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

class AskChatResult {
  String conversationId;
  String conversationName;
  String answer;
  bool success;
  String message;
  bool isFriendlyException;

  AskChatResult({
    required this.conversationId,
    required this.conversationName,
    required this.answer,
    required this.success,
    required this.message,
    required this.isFriendlyException,
  });

  factory AskChatResult.fromJson(Map<String, dynamic> json) => AskChatResult(
        conversationId:
            json["conversationId"] ?? "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        conversationName: json["conversationName"] ?? "Error Server",
        answer: json["answer"] == null || json["answer"] == ''
            ? L(LanguageCodes.errorServerTextInfo.toString())
            : json["answer"],
        success: json["success"] ?? false,
        message:
            json["message"] ?? L(LanguageCodes.errorServerTextInfo.toString()),
        isFriendlyException: json["isFriendlyException"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "conversationId": conversationId,
        "conversationName": conversationName,
        "answer": answer,
        "success": success,
        "message": message,
        "isFriendlyException": isFriendlyException,
      };
}
