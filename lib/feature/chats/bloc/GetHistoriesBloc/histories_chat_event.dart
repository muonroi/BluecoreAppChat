part of 'histories_chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatInfo extends ChatEvent {
  final String conversationId;
  const ChatInfo(this.conversationId);
}

class AskInfo extends ChatEvent {
  final String conversationId;
  final String askContent;
  const AskInfo(this.conversationId, this.askContent);
}
