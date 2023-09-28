part of 'get_all_chat_histories_bloc.dart';

abstract class GetAllChatHistoriesEvent extends Equatable {
  const GetAllChatHistoriesEvent();

  @override
  List<Object> get props => [];
}

class GetAllChat extends GetAllChatHistoriesEvent {
  const GetAllChat();
}
