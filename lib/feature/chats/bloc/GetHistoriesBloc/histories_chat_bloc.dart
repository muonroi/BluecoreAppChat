import 'package:bluecore/feature/chats/data/models/chats.ask.model.dart';
import 'package:bluecore/feature/chats/data/models/chats.histories.model.dart';
import 'package:bluecore/feature/chats/data/repository/repository.chats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'histories_chat_event.dart';
part 'histories_chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, MyChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatInfo>((event, emit) async {
      final ChatRepository chatRepository = ChatRepository();
      try {
        emit(ChatLoadingState());
        final mList =
            await chatRepository.getAllHistoriesChat(event.conversationId);
        emit(ChatLoadedState(mList, true));
      } on NetworkError {
        emit(const ChatErrorState(
            "Failed to fetch data. is your device online?"));
      }
    });
    on<AskInfo>((event, emit) async {
      final ChatRepository chatRepository = ChatRepository();
      try {
        emit(AskChatLoadingState(boolThinking: true));
        final mList = await chatRepository.askChat(
            event.conversationId, event.askContent);
        emit(AskChatLoadedState(mList, true));
      } on NetworkError {
        emit(const ChatErrorState(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
