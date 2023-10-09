import 'package:bluecore/feature/chats/data/models/chats.histories.model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

List<types.Message> convertAskChatModelToMessage(
    List<ChatHistoriesResult> chatHistoriesResult) {
  late List<types.Message> messages = [];
  for (int i = 0; i < chatHistoriesResult.length; i++) {
    final author = types.User(
        imageUrl:
            "https://imgtr.ee/images/2023/10/06/6f9c673cf19a9e7327c6c8caba4b6b35.png",
        id: chatHistoriesResult[i].role,
        firstName: chatHistoriesResult[i].role);
    // final message = types.TextMessage(
    //     author: author,
    //     createdAt: 1655648401000,
    //     id: const Uuid().v4(),
    //     type: types.MessageType.text,
    //     text: chatHistoriesResult[i].content);
    final message = types.CustomMessage(
        author: author,
        id: const Uuid().v4(),
        type: types.MessageType.custom,
        repliedMessage: types.TextMessage(
            author: author,
            createdAt: 1655648401000,
            id: const Uuid().v4(),
            type: types.MessageType.text,
            text: chatHistoriesResult[i].content));
    messages.add(message);
  }
  return messages;
}
