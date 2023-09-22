import 'dart:convert';

BaseOutputModel baseOutputFromJson(String str) =>
    BaseOutputModel.fromJson(json.decode(str));

String baseOutputToJson(BaseOutputModel data) => json.encode(data.toJson());

class BaseOutputModel {
  dynamic result;
  dynamic targetUrl;
  bool success;
  dynamic error;
  bool unAuthorizedRequest;
  bool abp;

  BaseOutputModel({
    required this.result,
    required this.targetUrl,
    required this.success,
    required this.error,
    required this.unAuthorizedRequest,
    required this.abp,
  });

  factory BaseOutputModel.fromJson(Map<String, dynamic> json) =>
      BaseOutputModel(
        result: json["result"],
        targetUrl: json["targetUrl"],
        success: json["success"],
        error: json["error"],
        unAuthorizedRequest: json["unAuthorizedRequest"],
        abp: json["__abp"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "targetUrl": targetUrl,
        "success": success,
        "error": error,
        "unAuthorizedRequest": unAuthorizedRequest,
        "__abp": abp,
      };
}
