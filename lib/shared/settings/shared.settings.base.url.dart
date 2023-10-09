class BaseApi {
  static const String apiVersion = "1.0";
  static const String baseUrl = "https://admin-apis-test.bluecore.vn/";
  static const String baseApi = "${baseUrl}api/services/app/";
  static const String authenticate = "${baseUrl}api/TokenAuth/Authenticate";
  static const String sendPassword = "Account/SendPasswordResetCode";
  static const String modelChatForTenant = "DataAssistant/GetListConversations";
  static const String getChatHistories =
      "DataAssistant/GetConversationMessages?conversationId=%s";
  static const String askChat = "DataAssistant/Ask";
  static const String removeSingleChat =
      "DataAssistant/DeleteConversation?conversationId=%s";
  static const String removeAllChat = "DataAssistant/DeleteAllConversations";
  static const String changeNameChat =
      "DataAssistant/UpdateConversationName?conversationId=%s&newName=%s";
  static const String chatUrl = "${baseUrl}signalr-dataAssistantHub";
}
