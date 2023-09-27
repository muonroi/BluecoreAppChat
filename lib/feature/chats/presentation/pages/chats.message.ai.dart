import 'dart:async';
import 'package:bluecore/core/localization/core.language_code.dart';
import 'package:bluecore/feature/accounts/presentation/pages/account.signin.page.dart';
import 'package:bluecore/feature/chats/bloc/GetAllChatHistories/get_all_chat_histories_bloc.dart';
import 'package:bluecore/feature/chats/bloc/GetHistoriesBloc/histories_chat_bloc.dart';
import 'package:bluecore/feature/chats/data/models/chats.message.custom.dart';
import 'package:bluecore/feature/chats/data/models/chats.user.model.dart';
import 'package:bluecore/feature/chats/data/repository/repository.chats.dart';
import 'package:bluecore/shared/models/model.divider.dart';
import 'package:bluecore/shared/settings/shared.settings.color.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:bluecore/shared/settings/shared.settings.font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MessageAiPage extends StatefulWidget {
  const MessageAiPage({super.key});

  @override
  State<MessageAiPage> createState() => _MessageAiPageState();
}

class _MessageAiPageState extends State<MessageAiPage> {
  @override
  void initState() {
    _drawerScaffoldKey = GlobalKey<ScaffoldState>();
    _allChatHistoriesBloc = GetAllChatHistoriesBloc();
    _chatBloc = ChatBloc();
    _allChatHistoriesBloc.add(const GetAllChat());
    _firstLoadHistory = false;
    _conversationId = '';
    _currentIndex = -1;
    _chatRepository = ChatRepository();
    super.initState();
    _initSharedPreferences();
  }

  @override
  void dispose() {
    _chatBloc.close();
    _allChatHistoriesBloc.close();
    super.dispose();
  }

  void _addMessage(types.Message message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        messages.insert(messages.length, message);
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
    _chatBloc.add(AskInfo(_conversationId, message.text));
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  SharedPreferences? _sharedPreferences;
  late GlobalKey<ScaffoldState> _drawerScaffoldKey;
  late GetAllChatHistoriesBloc _allChatHistoriesBloc;
  late ChatBloc _chatBloc;
  late List<types.Message> messages = [];
  final _user = DefaultTemplate.getUserTemplate();
  final _bot = DefaultTemplate.getBotTemplate();
  late bool _firstLoadHistory;
  late String _conversationId;
  late int _currentIndex;
  late ChatRepository _chatRepository;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _drawerScaffoldKey,
        appBar: AppBar(
          title: Title(
              color: ColorsGlobal.whiteColor,
              child: Text(
                L(LanguageCodes.supportedCustomerMessageChatTextInfo
                    .toString()),
                style: FontsGlobal.h5,
                textAlign: TextAlign.center,
              )),
          elevation: 0,
          backgroundColor: ColorsGlobal.whiteColor,
          actions: [
            IconButton(
                tooltip: L(LanguageCodes.newChatTextInfo.toString()),
                onPressed: () {
                  setState(() {
                    messages.clear();
                    _conversationId = '';
                  });
                },
                icon: const Icon(Icons.create_outlined))
          ],
          leading: IconButton(
              onPressed: () {
                if (_drawerScaffoldKey.currentState!.isDrawerOpen) {
                  Navigator.pop(context);
                } else {
                  if (_allChatHistoriesBloc.isClosed) {
                    _allChatHistoriesBloc = GetAllChatHistoriesBloc();
                    _allChatHistoriesBloc.add(const GetAllChat());
                  }
                  _drawerScaffoldKey.currentState!.openDrawer();
                }
              },
              icon: const Icon(Icons.menu)),
        ),
        drawer: Drawer(
            child: BlocProvider(
          create: (context) => _allChatHistoriesBloc,
          child:
              BlocListener<GetAllChatHistoriesBloc, GetAllChatHistoriesState>(
            listener: (context, state) {
              const Center(
                child: CircularProgressIndicator(),
              );
            },
            child:
                BlocBuilder<GetAllChatHistoriesBloc, GetAllChatHistoriesState>(
              builder: (context, state) {
                if (state is GetAllChatHistoriesLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetAllChatHistoriesLoadedState) {
                  return Container(
                    color: ColorsGlobal.whiteColor,
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          L(LanguageCodes.historiesMessageChatTextInfo
                              .toString()),
                          style: FontsGlobal.h4,
                        ),
                        actions: [
                          IconButton(
                              tooltip:
                                  L(LanguageCodes.logoutTextInfo.toString()),
                              onPressed: () async {
                                var userChoice = await _showConfirmationDialog(
                                    context,
                                    L(LanguageCodes.youSureLogoutTextInfo
                                        .toString()));
                                userChoice = userChoice ?? false;
                                if (userChoice && mounted) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    _sharedPreferences!.clear();
                                    return const AccountPage();
                                  }));
                                }
                              },
                              icon: const Icon(
                                Icons.logout_outlined,
                                color: ColorsGlobal.redColor,
                              )),
                        ],
                      ),
                      body: state.chatTenantModel.result.isEmpty
                          ? Center(
                              child: Text(
                                L(LanguageCodes
                                    .emptyHistoriesMessageChatTextInfo
                                    .toString()),
                                style: FontsGlobal.h5,
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.chatTenantModel.result.length,
                              itemBuilder: (context, index) {
                                var allChat = state.chatTenantModel.result;
                                var chatInfo = allChat[index];
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              index == 0
                                                  ? IconButton(
                                                      tooltip: L(LanguageCodes
                                                          .removeAllMessageChatTextInfo
                                                          .toString()),
                                                      onPressed: () async {
                                                        bool? userChoice =
                                                            await _showConfirmationDialog(
                                                                context,
                                                                L(LanguageCodes
                                                                    .isConfirmTextInfo
                                                                    .toString()));
                                                        userChoice =
                                                            userChoice ?? false;
                                                        if (userChoice) {
                                                          _chatRepository
                                                              .removeAllChat();
                                                          allChat.clear();
                                                        }
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.clear_all,
                                                        color: ColorsGlobal
                                                            .redColor,
                                                      ))
                                                  : Container(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(12.0),
                                      decoration: _currentIndex == index
                                          ? BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      ColorsGlobal.mainColor),
                                              color: ColorsGlobal.disableColor,
                                              borderRadius:
                                                  BorderRadius.circular(22.0),
                                            )
                                          : BoxDecoration(
                                              color: ColorsGlobal.disableColor,
                                              borderRadius:
                                                  BorderRadius.circular(22.0),
                                            ),
                                      child: TextButton(
                                        onPressed: () {
                                          _chatBloc
                                              .add(ChatInfo(chatInfo.value));
                                          setState(() {
                                            _currentIndex = index;
                                            _conversationId = chatInfo.value;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.chat_bubble_outline,
                                              color: ColorsGlobal.mainColor,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              width: getPercentageOfDevice(
                                                      context,
                                                      expectWidth: 130)
                                                  .width,
                                              child: Text(
                                                chatInfo.name,
                                                style: FontsGlobal.h5,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                                tooltip: L(LanguageCodes
                                                    .changeNameChatTextInfo
                                                    .toString()),
                                                onPressed: () {
                                                  if (_conversationId == '') {
                                                    showDialog(
                                                        context: context,
                                                        builder: (builder) {
                                                          return AlertDialog(
                                                            content: Text(
                                                              L(LanguageCodes
                                                                  .pleaseChooseChatIdTextInfo
                                                                  .toString()),
                                                              style: FontsGlobal
                                                                  .h6,
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (builder) {
                                                          return AlertDialog(
                                                              content:
                                                                  TextFormField(
                                                            initialValue:
                                                                chatInfo.name,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                allChat[index]
                                                                        .name =
                                                                    value;
                                                              });
                                                            },
                                                            obscureText: false,
                                                          ));
                                                        }).then((value) {
                                                      return _chatRepository
                                                          .changeChatName(
                                                              chatInfo.value,
                                                              chatInfo.name);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: ColorsGlobal.mainColor,
                                                )),
                                            IconButton(
                                                tooltip: L(LanguageCodes
                                                    .removeSingleChatTextInfo
                                                    .toString()),
                                                onPressed: () async {
                                                  bool? userChoice =
                                                      await _showConfirmationDialog(
                                                          context,
                                                          L(LanguageCodes
                                                              .isConfirmTextInfo
                                                              .toString()));
                                                  userChoice =
                                                      userChoice ?? false;
                                                  if (userChoice) {
                                                    _chatRepository
                                                        .removeSingleChat(
                                                            chatInfo.value);
                                                    allChat.removeWhere((el) =>
                                                        el.value ==
                                                        chatInfo.value);
                                                  }

                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: ColorsGlobal.redColor,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const DividerWidget(
                                        color:
                                            Color.fromARGB(119, 182, 181, 181)),
                                  ],
                                );
                              }),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        )),
        body: BlocProvider(
          create: (context) => _chatBloc,
          child: BlocListener<ChatBloc, MyChatState>(
            listener: (context, state) {
              Chat(
                customBottomWidget:
                    state is AskChatLoadingState ? TextFormField() : null,
                messages: messages.reversed.toList(),
                onSendPressed: _handleSendPressed,
                user: _user,
                showUserAvatars: true,
                showUserNames: true,
              );
            },
            child: BlocBuilder<ChatBloc, MyChatState>(
              builder: (context, state) {
                if (state is AskChatLoadingState) {
                  if (state.boolThinking) {
                    _addMessage(types.TextMessage(
                        author: _bot,
                        id: 'bot-thinking',
                        type: types.MessageType.text,
                        text: L(LanguageCodes.respondingTextInfo.toString())));
                    state.boolThinking = false;
                  }
                }
                if (state is AskChatLoadedState) {
                  messages
                      .removeWhere((element) => element.id == 'bot-thinking');
                  if (state.changeChatScreen) {
                    var answer = state.answerInfo.result!.answer;
                    _addMessage(types.TextMessage(
                        author: _bot,
                        id: const Uuid().v4(),
                        type: types.MessageType.text,
                        text: answer));
                    state.changeChatScreen = false;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      _conversationId = state.answerInfo.result!.conversationId;
                    });
                  });
                }
                if (state is ChatLoadedState) {
                  if (!_firstLoadHistory || state.changeChatScreen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        messages =
                            convertAskChatModelToMessage(state.chatInfo.result);
                        _firstLoadHistory = true;
                        state.changeChatScreen = false;
                      });
                    });
                  }
                  return Chat(
                    customBottomWidget:
                        state is AskChatLoadingState ? TextFormField() : null,
                    messages: messages.reversed.toList(),
                    onSendPressed: _handleSendPressed,
                    user: _user,
                    showUserAvatars: true,
                    showUserNames: true,
                  );
                }
                return Chat(
                  customBottomWidget:
                      state is AskChatLoadingState ? TextFormField() : null,
                  messages: messages.reversed.toList(),
                  onSendPressed: _handleSendPressed,
                  user: _user,
                  showUserAvatars: true,
                  showUserNames: true,
                );
              },
            ),
          ),
        ));
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String notification) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            L(LanguageCodes.notificationTextInfo.toString()),
            style: FontsGlobal.h4,
          ),
          content: Text(
            notification,
            style: FontsGlobal.h6,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                L(LanguageCodes.isNotSureTextInfo.toString()),
                style: FontsGlobal.h6,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                L(LanguageCodes.isSureTextInfo.toString()),
                style: FontsGlobal.h6,
              ),
            ),
          ],
        );
      },
    );
  }
}
