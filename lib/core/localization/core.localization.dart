import 'package:bluecore_appchat/core/localization/core.language.dart';
import 'package:bluecore_appchat/core/localization/core.language_code.dart';

class LocalizationLib {
  static final Map<String, Map<String, String>> _localizedValues = {
    Languages.en: {},
    Languages.vi: {
      LanguageCodes.notfoundTextInfo.toString(): 'Không xác định',
    }
  };
  static String L(String key, {String locale = 'vi'}) {
    return _localizedValues[locale]![key] ??
        _localizedValues[locale]![LanguageCodes.notfoundTextInfo.toString()]!;
  }
}
