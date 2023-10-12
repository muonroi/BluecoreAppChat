import 'dart:convert';

ChatTenantModel chatTenantModelFromJson(String str) =>
    ChatTenantModel.fromJson(json.decode(str));

String chatTenantModelToJson(ChatTenantModel data) =>
    json.encode(data.toJson());

class ChatTenantModel {
  List<Result> result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool unAuthorizedRequest;
  bool abp;

  ChatTenantModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory ChatTenantModel.fromJson(Map<String, dynamic> json) =>
      ChatTenantModel(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
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

class Result {
  String name;
  String value;

  Result({
    required this.name,
    required this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"] ?? "Anonymous",
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
