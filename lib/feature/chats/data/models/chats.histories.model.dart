// To parse this JSON data, do
//
//     final chatHistoriesModel = chatHistoriesModelFromJson(jsonString);

import 'dart:convert';

ChatHistoriesModel chatHistoriesModelFromJson(String str) =>
    ChatHistoriesModel.fromJson(json.decode(str));

String chatHistoriesModelToJson(ChatHistoriesModel data) =>
    json.encode(data.toJson());

class ChatHistoriesModel {
  List<ChatHistoriesResult> result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool unAuthorizedRequest;
  bool abp;

  ChatHistoriesModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory ChatHistoriesModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoriesModel(
        result: List<ChatHistoriesResult>.from(
            json["result"].map((x) => ChatHistoriesResult.fromJson(x))),
        targetUrl: json["targetUrl"],
        success: json["success"],
        error: json["error"],
        unAuthorizedRequest: json["unAuthorizedRequest"],
        abp: json["__abp"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "targetUrl": targetUrl,
        "success": success,
        "error": error,
        "unAuthorizedRequest": unAuthorizedRequest,
        "__abp": abp,
      };
}

class ChatHistoriesResult {
  dynamic tenantId;
  String conversationId;
  String role;
  String content;
  DateTime creationTime;
  dynamic creatorUserId;
  String id;

  ChatHistoriesResult({
    required this.tenantId,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.creationTime,
    required this.creatorUserId,
    required this.id,
  });

  factory ChatHistoriesResult.fromJson(Map<String, dynamic> json) =>
      ChatHistoriesResult(
        tenantId: json["tenantId"],
        conversationId: json["conversationId"],
        role: json["role"],
        content: json["content"],
        creationTime: DateTime.parse(json["creationTime"]),
        creatorUserId: json["creatorUserId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "tenantId": tenantId,
        "conversationId": conversationId,
        "role": role,
        "content": content,
        "creationTime": creationTime.toIso8601String(),
        "creatorUserId": creatorUserId,
        "id": id,
      };
}
