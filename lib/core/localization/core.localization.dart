import 'package:bluecore_appchat/core/localization/core.language.dart';
import 'package:bluecore_appchat/core/localization/core.language_code.dart';

class LocalizationLib {
  static final Map<String, Map<String, String>> _localizedValues = {
    Languages.en: {},
    Languages.vi: {
      LanguageCodes.notfoundTextInfo.toString(): 'Không xác định',
      LanguageCodes.usernameTextInfo.toString(): 'Tài khoản hoặc email',
      LanguageCodes.passwordTextInfo.toString(): 'Mật khẩu',
      LanguageCodes.noAccountTextInfo.toString(): 'Chưa có tài khoản?',
      LanguageCodes.initAccountTextInfo.toString(): 'Tạo tài khoản',
      LanguageCodes.forgotPasswordTextInfo.toString(): 'Quên mật khẩu',
      LanguageCodes.invalidAccountTextInfo.toString():
          'Tên tài khoản hoặc mật khẩu không chính xác',
      LanguageCodes.rememberTextInfo.toString(): 'Ghi nhớ',
      LanguageCodes.submitTextInfo.toString(): 'Gửi',
      LanguageCodes.forgotPasswordMoreInfoTextInfo.toString():
          'Một liên kết đặt lại mật khẩu sẽ được gửi đến email của bạn để đặt lại mật khẩu. Nếu bạn không nhận được email trong vòng vài phút, vui lòng thử lại.',
      LanguageCodes.backInfoTextInfo.toString(): 'Quay lại',
    }
  };
  static String L(String key, {String locale = 'vi'}) {
    return _localizedValues[locale]![key] ??
        _localizedValues[locale]![LanguageCodes.notfoundTextInfo.toString()]!;
  }
}
