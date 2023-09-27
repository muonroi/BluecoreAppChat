part of 'get_all_chat_histories_bloc.dart';

sealed class GetAllChatHistoriesState extends Equatable {
  const GetAllChatHistoriesState();

  @override
  List<Object> get props => [];
}

final class GetAllChatHistoriesInitial extends GetAllChatHistoriesState {}

class GetAllChatHistoriesLoadingState extends GetAllChatHistoriesState {}

class GetAllChatHistoriesLoadedState extends GetAllChatHistoriesState {
  final ChatTenantModel chatTenantModel;
  const GetAllChatHistoriesLoadedState(this.chatTenantModel);
}

class ChatErrorState extends GetAllChatHistoriesState {
  final String error;
  const ChatErrorState(this.error);
}
