part of 'histories_chat_bloc.dart';

sealed class MyChatState extends Equatable {
  const MyChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends MyChatState {}

class ChatLoadingState extends MyChatState {}

// ignore: must_be_immutable
class ChatLoadedState extends MyChatState {
  final ChatHistoriesModel chatInfo;
  late bool changeChatScreen;
  ChatLoadedState(this.chatInfo, this.changeChatScreen);
}

// ignore: must_be_immutable
class AskChatLoadingState extends MyChatState {
  late bool boolThinking;
  AskChatLoadingState({required this.boolThinking});
}

// ignore: must_be_immutable
class AskChatLoadedState extends MyChatState {
  final AskChatModel answerInfo;
  late bool changeChatScreen;

  AskChatLoadedState(this.answerInfo, this.changeChatScreen);
}

class ChatErrorState extends MyChatState {
  final String error;
  const ChatErrorState(this.error);
}
