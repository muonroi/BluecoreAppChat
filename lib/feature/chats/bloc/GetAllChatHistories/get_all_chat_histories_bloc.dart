import 'package:bloc/bloc.dart';
import 'package:bluecore/feature/chats/data/models/chats.tenant.model.dart';
import 'package:bluecore/feature/chats/data/repository/repository.chats.dart';
import 'package:equatable/equatable.dart';
part 'get_all_chat_histories_event.dart';
part 'get_all_chat_histories_state.dart';

class GetAllChatHistoriesBloc
    extends Bloc<GetAllChatHistoriesEvent, GetAllChatHistoriesState> {
  GetAllChatHistoriesBloc() : super(GetAllChatHistoriesInitial()) {
    on<GetAllChatHistoriesEvent>((event, emit) async {
      final ChatRepository chatRepository = ChatRepository();
      try {
        emit(GetAllChatHistoriesLoadingState());
        final mList = await chatRepository.getModelChat();
        emit(GetAllChatHistoriesLoadedState(mList));
      } on NetworkError {
        emit(const ChatErrorState(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
