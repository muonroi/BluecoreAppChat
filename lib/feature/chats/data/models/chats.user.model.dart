import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DefaultTemplate {
  static types.User getUserTemplate() {
    return const types.User(
        id: 'user',
        imageUrl:
            "https://w7.pngwing.com/pngs/146/551/png-transparent-user-login-mobile-phones-password-user-miscellaneous-blue-text.png",
        firstName: 'You');
  }

  static types.User getBotTemplate() {
    return const types.User(
        id: 'assistant',
        imageUrl:
            "https://static.vecteezy.com/system/resources/previews/004/996/790/non_2x/robot-chatbot-icon-sign-free-vector.jpg",
        firstName: 'Bot Bluecore');
  }
}
