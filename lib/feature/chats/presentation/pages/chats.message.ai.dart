import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:bluecore/core/localization/core.language.dart';
import 'package:bluecore/core/localization/core.language_code.dart';
import 'package:bluecore/core/signalr/signalr.central.dart';
import 'package:bluecore/feature/accounts/data/repository/repository.account.dart';
import 'package:bluecore/feature/accounts/presentation/pages/account.signin.page.dart';
import 'package:bluecore/feature/chats/bloc/GetAllChatHistories/get_all_chat_histories_bloc.dart';
import 'package:bluecore/feature/chats/bloc/GetHistoriesBloc/histories_chat_bloc.dart';
import 'package:bluecore/feature/chats/data/models/chats.message.custom.dart';
import 'package:bluecore/feature/chats/data/models/chats.user.model.dart';
import 'package:bluecore/feature/chats/data/repository/repository.chats.dart';
import 'package:bluecore/feature/chats/provider/provider.chat.dart';
import 'package:bluecore/feature/chats/settings/enums/cache.enums.dart';
import 'package:bluecore/shared/models/model.divider.dart';
import 'package:bluecore/shared/settings/shared.settings.color.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:bluecore/shared/settings/shared.settings.font.dart';
import 'package:bluecore/shared/settings/shared.settings.image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:bluecore/feature/chats/settings/setting.chat.dart';

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
    status = '';
    _textEditingController = TextEditingController();
    _hubConnection =
        HubConnectionBuilder().withUrl(SignalrCentral.chatStatus).build();
    _initSharedPreferences().then((value) {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
              sprintf(SignalrCentral.chatStatus, [
                Uri.encodeComponent(
                    _sharedPreferences.getString(KeyToken.encToken.name)!)
              ]),
              options: SignalrCentral.httpConnectionOptions)
          .withAutomaticReconnect(retryDelays: [25000]).build();
      initHubAndListenStatus();
      _hubConnection.onclose(({error}) {
        debugPrint(error.toString());
        _hubConnection.onreconnecting(({error}) {});
        _hubConnection.onreconnected(({connectionId}) {});
      });
    });
    _accountRepository = AccountRepository('', '');
    super.initState();
    _speech = stt.SpeechToText();
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

  void _handleSendPressed(String message) {
    final textMessage = types.CustomMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      repliedMessage: types.TextMessage(
          author: _user,
          createdAt: 1655648401000,
          id: const Uuid().v4(),
          type: types.MessageType.text,
          text: message),
    );
    _addMessage(textMessage);
    _chatBloc.add(AskInfo(_conversationId, message));
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initHubAndListenStatus() async {
    await _hubConnection.start();
    debugPrint('start');
  }

  late HubConnection _hubConnection;
  late String status;
  late SharedPreferences _sharedPreferences;
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
  late TextEditingController _textEditingController;
  late bool _isShowSend = false;
  late stt.SpeechToText _speech;
  late bool _isListening = false;
  late String _text = '';
  late AccountRepository _accountRepository;
  @override
  Widget build(BuildContext context) {
    Widget customMessageBuilder(types.CustomMessage customMessage,
        {required int messageWidth}) {
      bool isBot(String id) => id == DefaultTemplate.getBotTemplate().id;
      var content = customMessage.repliedMessage as types.TextMessage;
      return Stack(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isBot(content.author.id)
                ? ColorsGlobal.customerChatColor
                : ColorsGlobal.mainColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height:
                              getPercentageOfDevice(context, expectHeight: 80)
                                  .height,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: menuWidget(context, content.text!),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: MarkdownBody(
                    onTapLink: (text, href, title) async {
                      await launchUrl(Uri.parse(href!));
                    },
                    onTapText: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height:
                                getPercentageOfDevice(context, expectHeight: 80)
                                    .height,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: menuWidget(context, content.text!),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    selectable: true,
                    data: content.text!,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: isBot(content.author.id)
                          ? const TextStyle(color: ColorsGlobal.textColor)
                          : const TextStyle(color: ColorsGlobal.whiteColor),
                      textScaleFactor: 1,
                    ),
                  )
                  // : ParsedText(
                  //     onTap: () {},
                  //     text: content.text!,
                  //     selectable: true,
                  //     style: isBot(content.author.id)
                  //         ? FontsGlobal.h5
                  //         : FontsGlobal.h5
                  //             .copyWith(color: ColorsGlobal.whiteColor),
                  //     regexOptions:
                  //         const RegexOptions(multiLine: true, dotAll: true),
                  //     parse: [
                  //       MatchText(
                  //         pattern:
                  //             '\\|(?:([^\r\n|]*)\\|)+\r?\n\\|(?:(:?-+:?)\\|)+\r?\n(\\|(?:([^\r\n|]*)\\|)+\r?\n)+',
                  //         onTap: (url) {
                  //           prePreviewTable(context, url);
                  //         },
                  //         style: FontsGlobal.h5,
                  //         renderWidget: renderMarkdownWidget,
                  //       ),
                  //       MatchText(
                  //         pattern: regexLink,
                  //         onTap: (url) async {
                  //           debugPrint(url);
                  //           if (await canLaunchUrl(Uri.parse(url))) {
                  //             await launchUrl(Uri.parse(url));
                  //           }
                  //         },
                  //         style: FontsGlobal.h5
                  //             .copyWith(decoration: TextDecoration.underline),
                  //         renderWidget: renderMarkdownWidget,
                  //       ),
                  //       MatchText(
                  //         pattern: '(\\*\\*|\\*)(.*?)(\\*\\*|\\*)',
                  //         onTap: (_) {},
                  //         style: FontsGlobal.h5
                  //             .copyWith(fontWeight: FontWeight.w700),
                  //         renderText: (
                  //             {required String str,
                  //             required String pattern}) {
                  //           return {
                  //             'display':
                  //                 str.replaceAll(RegExp('(\\*\\*|\\*)'), '')
                  //           };
                  //         },
                  //       ),
                  //       MatchText(
                  //         pattern: "\\[([^\\]]*)\\]\\(.*\\)",
                  //         onTap: (str) async {
                  //           RegExp regex = RegExp(r'\[.*\]\((.*)\)');
                  //           Match match = regex.firstMatch(str)!;
                  //           if (await canLaunchUrl(
                  //               Uri.parse(match.group(1)!))) {
                  //             await launchUrl(Uri.parse(match.group(1)!));
                  //           }
                  //         },
                  //         style: FontsGlobal.h5
                  //             .copyWith(fontWeight: FontWeight.w700),
                  //         renderText: (
                  //             {required String str,
                  //             required String pattern}) {
                  //           return {
                  //             'display':
                  //                 str.replaceAll(RegExp('\\(.*\\)'), '')
                  //           };
                  //         },
                  //       ),
                  //       MatchText(
                  //         pattern: '_(.*?)_',
                  //         onTap: (_) {},
                  //         style: FontsGlobal.h5
                  //             .copyWith(fontStyle: FontStyle.italic),
                  //         renderText: (
                  //             {required String str,
                  //             required String pattern}) {
                  //           return {'display': str.replaceAll('_', '')};
                  //         },
                  //       ),
                  //       MatchText(
                  //         pattern: '~(.*?)~',
                  //         onTap: (_) {},
                  //         style: FontsGlobal.h5.copyWith(
                  //           decoration: TextDecoration.lineThrough,
                  //         ),
                  //         renderText: (
                  //             {required String str,
                  //             required String pattern}) {
                  //           return {'display': str.replaceAll('~', '')};
                  //         },
                  //       ),
                  //       MatchText(
                  //         pattern: '`(.*?)`',
                  //         onTap: (_) {},
                  //         style: FontsGlobal.h5.copyWith(
                  //           fontFamily:
                  //               Platform.isIOS ? 'Courier' : 'monospace',
                  //         ),
                  //         renderText: (
                  //             {required String str,
                  //             required String pattern}) {
                  //           return {'display': str.replaceAll('`', '')};
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  ),
            ],
          ),
        ),
      ]);
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: _drawerScaffoldKey,
        appBar: AppBar(
          title: Title(
              color: ColorsGlobal.whiteColor,
              child: Text(
                L(
                    context,
                    LanguageCodes.supportedCustomerMessageChatTextInfo
                        .toString()),
                style: FontsGlobal.h5,
                textAlign: TextAlign.center,
              )),
          elevation: 0,
          backgroundColor: ColorsGlobal.whiteColor,
          actions: [
            IconButton(
                tooltip: L(context, LanguageCodes.newChatTextInfo.toString()),
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
                          L(
                              context,
                              LanguageCodes.historiesMessageChatTextInfo
                                  .toString()),
                          style: FontsGlobal.h4,
                        ),
                        actions: [
                          Consumer<ChatProvider>(
                            builder: (BuildContext context, ChatProvider value,
                                Widget? child) {
                              return IconButton(
                                  tooltip: L(context,
                                      LanguageCodes.logoutTextInfo.toString()),
                                  onPressed: () async {
                                    showMenu(
                                        context: context,
                                        position: const RelativeRect.fromLTRB(
                                            100, 80, 90, 10),
                                        items: [
                                          PopupMenuItem<String>(
                                            value: Languages.en,
                                            child: Center(
                                              child: IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      value.changeLanguage =
                                                          Languages.en;
                                                    });
                                                    await _accountRepository
                                                        .changeLanguage(
                                                            Languages.en);
                                                    _sharedPreferences
                                                        .setString(
                                                            CacheChatEnum
                                                                .currentLanguage
                                                                .name,
                                                            Languages.en);
                                                  },
                                                  icon: SizedBox(
                                                      width:
                                                          getPercentageOfDevice(
                                                                  context,
                                                                  expectWidth:
                                                                      50)
                                                              .width,
                                                      height:
                                                          getPercentageOfDevice(
                                                                  context,
                                                                  expectHeight:
                                                                      50)
                                                              .height,
                                                      child: Image.asset(
                                                          ImagesGlobal.us2x,
                                                          fit: BoxFit.fill))),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: Languages.vi,
                                            child: Center(
                                              child: IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      value.changeLanguage =
                                                          Languages.vi;
                                                    });
                                                    await _accountRepository
                                                        .changeLanguage(
                                                            Languages.vi);
                                                    _sharedPreferences
                                                        .setString(
                                                            CacheChatEnum
                                                                .currentLanguage
                                                                .name,
                                                            Languages.vi);
                                                  },
                                                  icon: SizedBox(
                                                      width:
                                                          getPercentageOfDevice(
                                                                  context,
                                                                  expectWidth:
                                                                      50)
                                                              .width,
                                                      height:
                                                          getPercentageOfDevice(
                                                                  context,
                                                                  expectHeight:
                                                                      50)
                                                              .height,
                                                      child: Image.asset(
                                                          ImagesGlobal.vi2x,
                                                          fit: BoxFit.fill))),
                                            ),
                                          ),
                                        ]);
                                  },
                                  icon: const Icon(
                                    Icons.language_outlined,
                                    color: ColorsGlobal.mainColor,
                                  ));
                            },
                          ),
                          IconButton(
                              tooltip: L(context,
                                  LanguageCodes.logoutTextInfo.toString()),
                              onPressed: () async {
                                var userChoice = await showConfirmationDialog(
                                    context,
                                    L(
                                        context,
                                        LanguageCodes.youSureLogoutTextInfo
                                            .toString()),
                                    null);
                                userChoice = userChoice ?? false;
                                if (userChoice && mounted) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    _sharedPreferences
                                        .remove(KeyToken.accessToken.name);
                                    _sharedPreferences
                                        .remove(KeyToken.refreshToken.name);
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
                                L(
                                    context,
                                    LanguageCodes
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
                                                      tooltip: L(
                                                          context,
                                                          LanguageCodes
                                                              .removeAllMessageChatTextInfo
                                                              .toString()),
                                                      onPressed: () async {
                                                        bool? userChoice = await showConfirmationDialog(
                                                            context,
                                                            L(
                                                                context,
                                                                LanguageCodes
                                                                    .isConfirmTextInfo
                                                                    .toString()),
                                                            L(
                                                                context,
                                                                LanguageCodes
                                                                    .removeAllMessageChatTextInfo
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
                                                tooltip: L(
                                                    context,
                                                    LanguageCodes
                                                        .changeNameChatTextInfo
                                                        .toString()),
                                                onPressed: () {
                                                  if (_conversationId == '') {
                                                    showDialog(
                                                        context: context,
                                                        builder: (builder) {
                                                          return AlertDialog(
                                                            content: Text(
                                                              L(
                                                                  context,
                                                                  LanguageCodes
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
                                                tooltip: L(
                                                    context,
                                                    LanguageCodes
                                                        .removeSingleChatTextInfo
                                                        .toString()),
                                                onPressed: () async {
                                                  bool? userChoice =
                                                      await showConfirmationDialog(
                                                          context,
                                                          L(
                                                              context,
                                                              LanguageCodes
                                                                  .isConfirmTextInfo
                                                                  .toString()),
                                                          L(
                                                              context,
                                                              LanguageCodes
                                                                  .removeSingleChatTextInfo
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
                customMessageBuilder: customMessageBuilder,
                customBottomWidget: state is AskChatLoadingState
                    ? Container()
                    : SizedBox(
                        child: TextFormField(
                        onChanged: (value) {
                          _isShowSend = value.isNotEmpty;
                          setState(() {});
                        },
                        controller: _textEditingController,
                        obscureText: false,
                        decoration: !_isListening
                            ? InputDecoration(
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0))),
                                hintText: L(
                                    context,
                                    LanguageCodes
                                        .enterContentMessageChatTextInfo
                                        .toString()),
                                hintStyle: FontsGlobal.h6
                                    .copyWith(fontStyle: FontStyle.italic),
                                prefixIcon: const Icon(Icons.message_outlined),
                                suffixIcon: _isShowSend
                                    ? IconButton(
                                        onPressed: () {
                                          _handleSendPressed(
                                              _textEditingController.text);
                                          _textEditingController.clear();
                                          _isShowSend = false;
                                        },
                                        icon: const Icon(Icons.send),
                                      )
                                    : IconButton(
                                        onPressed: _listen,
                                        icon: const Icon(Icons.mic),
                                      ))
                            : null,
                      )),
                messages: messages.reversed.toList(),
                onSendPressed: (_) {},
                user: _user,
                showUserAvatars: true,
                showUserNames: true,
              );
            },
            child: BlocBuilder<ChatBloc, MyChatState>(
              builder: (context, state) {
                if (state is ChatLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is AskChatLoadingState) {
                  if (state.boolThinking) {
                    _addMessage(types.TextMessage(
                      author: _bot,
                      id: 'bot-thinking',
                      type: types.MessageType.text,
                      text: L(
                          context, LanguageCodes.respondingTextInfo.toString()),
                    ));
                    state.boolThinking = false;
                  }
                  if (_hubConnection.state == HubConnectionState.Connected) {
                    _hubConnection.on('getStatus', (arguments) {
                      int indexToChange = messages.indexWhere(
                          (element) => element.id == 'bot-thinking');
                      var message =
                          messages[indexToChange] as types.TextMessage;
                      message.text = arguments!.first.toString();
                      messages[indexToChange] = message;
                      setState(() {});
                    });
                  } else if (_hubConnection.state ==
                      HubConnectionState.Disconnected) {
                    initHubAndListenStatus();
                  }
                }
                if (state is AskChatLoadedState) {
                  messages
                      .removeWhere((element) => element.id == 'bot-thinking');
                  if (state.changeChatScreen) {
                    var answer = state.answerInfo.result!.answer;
                    _addMessage(types.CustomMessage(
                        author: _bot,
                        id: const Uuid().v4(),
                        type: types.MessageType.custom,
                        repliedMessage: types.TextMessage(
                            author: _bot,
                            createdAt: 1655648401000,
                            id: const Uuid().v4(),
                            type: types.MessageType.text,
                            text: answer)));
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
                    customMessageBuilder: customMessageBuilder,
                    customBottomWidget: state is AskChatLoadingState
                        ? Container()
                        : SizedBox(
                            child: !_isListening
                                ? TextFormField(
                                    controller: _textEditingController,
                                    onChanged: (value) {
                                      _isShowSend = value.isNotEmpty;
                                      setState(() {});
                                    },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0))),
                                        hintText: L(
                                            context,
                                            LanguageCodes
                                                .enterContentMessageChatTextInfo
                                                .toString()),
                                        hintStyle: FontsGlobal.h6.copyWith(
                                            fontStyle: FontStyle.italic),
                                        prefixIcon:
                                            const Icon(Icons.message_outlined),
                                        suffixIcon: _isShowSend
                                            ? IconButton(
                                                onPressed: () {
                                                  _handleSendPressed(
                                                      _textEditingController
                                                          .text);
                                                  _textEditingController
                                                      .clear();
                                                  _isShowSend = false;
                                                },
                                                icon: const Icon(Icons.send),
                                              )
                                            : IconButton(
                                                onPressed: _listen,
                                                icon: const Icon(Icons.mic),
                                              )),
                                  )
                                : null),
                    messages: messages.reversed.toList(),
                    onSendPressed: (_) {},
                    user: _user,
                    showUserAvatars: true,
                    showUserNames: true,
                  );
                }
                return Chat(
                  customMessageBuilder: customMessageBuilder,
                  customBottomWidget: state is AskChatLoadingState
                      ? Container()
                      : SizedBox(
                          child: !_isListening
                              ? TextFormField(
                                  onChanged: (value) {
                                    _isShowSend = value.isNotEmpty;
                                    setState(() {});
                                  },
                                  controller: _textEditingController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              bottomLeft:
                                                  Radius.circular(8.0))),
                                      hintText: L(
                                          context,
                                          LanguageCodes
                                              .enterContentMessageChatTextInfo
                                              .toString()),
                                      hintStyle: FontsGlobal.h6.copyWith(
                                          fontStyle: FontStyle.italic),
                                      prefixIcon:
                                          const Icon(Icons.message_outlined),
                                      suffixIcon: _isShowSend
                                          ? IconButton(
                                              onPressed: () {
                                                _handleSendPressed(
                                                    _textEditingController
                                                        .text);
                                                _textEditingController.clear();
                                                _isShowSend = false;
                                              },
                                              icon: const Icon(Icons.send),
                                            )
                                          : IconButton(
                                              onPressed: _listen,
                                              icon: const Icon(Icons.mic),
                                            )),
                                )
                              : null),
                  messages: messages.reversed.toList(),
                  onSendPressed: (_) {},
                  user: _user,
                  showUserAvatars: true,
                  showUserNames: true,
                );
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isListening
            ? AvatarGlow(
                animate: _isListening,
                glowColor: ColorsGlobal.mainColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: FloatingActionButton(
                  onPressed: _stopListening,
                  child: _isListening
                      ? const Icon(Icons.mic)
                      : const Icon(Icons.mic_none),
                ),
              )
            : null);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: 'vi_VN',
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            _textEditingController.text = _text;
            _isShowSend = true;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }
}
