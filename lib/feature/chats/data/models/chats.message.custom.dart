import 'package:bluecore/feature/chats/data/models/chats.histories.model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

List<types.Message> convertAskChatModelToMessage(
    List<ChatHistoriesResult> chatHistoriesResult) {
  late List<types.Message> messages = [];
  for (int i = 0; i < chatHistoriesResult.length; i++) {
    final author = types.User(
        imageUrl:
            "https://static.vecteezy.com/system/resources/previews/004/996/790/non_2x/robot-chatbot-icon-sign-free-vector.jpg",
        id: chatHistoriesResult[i].role,
        firstName: chatHistoriesResult[i].role);
    final message = types.TextMessage(
        author: author,
        createdAt: 1655648401000,
        id: const Uuid().v4(),
        type: types.MessageType.text,
        text: chatHistoriesResult[i].content);
    messages.add(message);
  }
  return messages;
}
