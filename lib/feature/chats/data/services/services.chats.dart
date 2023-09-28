import 'package:bluecore/core/localization/core.language_code.dart';
import 'package:bluecore/feature/chats/data/models/chats.ask.model.dart';
import 'package:bluecore/feature/chats/data/models/chats.histories.model.dart';
import 'package:bluecore/feature/chats/data/models/chats.tenant.model.dart';
import 'package:bluecore/shared/models/model.baseoutput.dart';
import 'package:bluecore/shared/settings/shared.settings.base.url.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class ServiceChats {
  Future<ChatHistoriesModel> getAllChats(String conversationId) async {
    try {
      var dio = await getBaseApi();
      final response = await dio.get(
        sprintf(BaseApi.getChatHistories, [conversationId]),
      );
      if (response.statusCode == 200) {
        return chatHistoriesModelFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return ChatHistoriesModel(
          result: [],
          targetUrl: null,
          success: false,
          error: null,
          unAuthorizedRequest: false,
          abp: false,
        );
      }
    }
    return ChatHistoriesModel(
      result: [],
      targetUrl: null,
      success: false,
      error: null,
      unAuthorizedRequest: false,
      abp: false,
    );
  }

  Future<ChatTenantModel> getChatsInfoByTenant() async {
    try {
      var dio = await getBaseApi();
      final response = await dio.get(
        BaseApi.modelChatForTenant,
      );
      if (response.statusCode == 200) {
        return chatTenantModelFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return ChatTenantModel(
          result: [],
          targetUrl: null,
          success: false,
          error: null,
          unAuthorizedRequest: false,
          abp: false,
        );
      }
    }
    return ChatTenantModel(
      result: [],
      targetUrl: null,
      success: false,
      error: null,
      unAuthorizedRequest: false,
      abp: false,
    );
  }

  Future<AskChatModel> askChatForTenant(
      String? conversationId, String askContent) async {
    try {
      var uuid = const Uuid();
      final Map<String, dynamic> body = {
        'conversationId': conversationId ?? uuid.v4(),
        'question': askContent
      };
      var dio = await getBaseApi();
      final response = await dio.post(BaseApi.askChat, data: body);
      if (response.statusCode == 200) {
        return askChatModelFromJson(response.data.toString());
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return AskChatModel(
          result: AskChatResult(
              conversationId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
              conversationName: "Error",
              answer: L(LanguageCodes.errorServerTextInfo.toString()),
              success: false,
              message: L(LanguageCodes.errorServerTextInfo.toString()),
              isFriendlyException: true),
          targetUrl: null,
          success: false,
          error: null,
          unAuthorizedRequest: false,
          abp: false,
        );
      }
    }
    return AskChatModel(
      result: AskChatResult(
          conversationId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          conversationName: "Error",
          answer: L(LanguageCodes.errorServerTextInfo.toString()),
          success: false,
          message: L(LanguageCodes.errorServerTextInfo.toString()),
          isFriendlyException: true),
      targetUrl: null,
      success: false,
      error: null,
      unAuthorizedRequest: false,
      abp: false,
    );
  }

  Future<BaseOutputModel> removeSingleChat(String conversationId) async {
    try {
      var dio = await getBaseApi();
      final response =
          await dio.delete(sprintf(BaseApi.removeSingleChat, [conversationId]));
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

  Future<BaseOutputModel> removeAllChat() async {
    try {
      var dio = await getBaseApi();
      final response = await dio.delete(BaseApi.removeAllChat);
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

  Future<BaseOutputModel> changeNameOfChat(
      String conversationId, String newName) async {
    try {
      var dio = await getBaseApi();
      final response = await dio
          .put(sprintf(BaseApi.changeNameChat, [conversationId, newName]));
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
