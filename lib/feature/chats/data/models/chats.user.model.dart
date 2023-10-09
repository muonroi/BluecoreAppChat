import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DefaultTemplate {
  static types.User getUserTemplate() {
    return const types.User(id: 'user', firstName: 'You');
  }

  static types.User getBotTemplate() {
    return const types.User(
      id: 'assistant',
      imageUrl:
          "https://imgtr.ee/images/2023/10/06/6f9c673cf19a9e7327c6c8caba4b6b35.png",
      firstName: 'Bot Bluecore',
    );
  }
}
