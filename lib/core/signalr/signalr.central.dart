import 'package:bluecore/shared/settings/shared.settings.base.url.dart';
import 'package:bluecore/shared/settings/shared.settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/ihub_protocol.dart';

class SignalrCentral {
  static MessageHeaders getHeader() {
    final defaultHeaders = MessageHeaders();
    defaultHeaders.setHeaderValue("Culture", "c=vi|uic=vi");
    return defaultHeaders;
  }

  static final httpConnectionOptions = HttpConnectionOptions(
    headers: getHeader(),
    accessTokenFactory: () async {
      var sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString(KeyToken.accessToken.name)!;
    },
  );

  static const String chatStatus = BaseApi.chatUrl;
}
