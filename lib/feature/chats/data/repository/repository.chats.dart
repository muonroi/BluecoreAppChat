import 'package:bluecore/feature/chats/data/models/chats.ask.model.dart';
import 'package:bluecore/feature/chats/data/models/chats.histories.model.dart';
import 'package:bluecore/feature/chats/data/models/chats.tenant.model.dart';
import 'package:bluecore/feature/chats/data/services/services.chats.dart';
import 'package:bluecore/shared/models/model.baseoutput.dart';

class ChatRepository {
  final serviceChat = ServiceChats();

  ChatRepository();

  Future<ChatHistoriesModel> getAllHistoriesChat(String conversationId) =>
      serviceChat.getAllChats(conversationId);

  Future<ChatTenantModel> getModelChat() => serviceChat.getChatsInfoByTenant();

  Future<AskChatModel> askChat(String conversationId, String askContent) =>
      serviceChat.askChatForTenant(conversationId, askContent);

  Future<BaseOutputModel> removeSingleChat(String conversationId) =>
      serviceChat.removeSingleChat(conversationId);

  Future<BaseOutputModel> removeAllChat() => serviceChat.removeAllChat();

  Future<BaseOutputModel> changeChatName(
          String conversationId, String newName) =>
      serviceChat.changeNameOfChat(conversationId, newName);
}

class NetworkError extends Error {}
