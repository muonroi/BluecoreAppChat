import 'dart:io';

import 'package:bluecore/feature/accounts/presentation/pages/account.signin.page.dart';
import 'package:bluecore/feature/chats/presentation/pages/chats.message.ai.dart';
import 'package:bluecore/feature/chats/provider/provider.chat.dart';
import 'package:bluecore/shared/settings/shared.settings.color.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ChatBotBluecoreApp());
}

class ChatBotBluecoreApp extends StatefulWidget {
  const ChatBotBluecoreApp({super.key});

  @override
  State<ChatBotBluecoreApp> createState() => _ChatBotBluecoreAppState();
}

class _ChatBotBluecoreAppState extends State<ChatBotBluecoreApp> {
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  SharedPreferences? _sharedPreferences;
  @override
  Widget build(BuildContext context) {
    if (_sharedPreferences == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorsGlobal.mainColor),
          useMaterial3: true,
        ),
        home: _sharedPreferences!.getString(KeyToken.accessToken.name) == null
            ? const AccountPage()
            : const MessageAiPage(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
