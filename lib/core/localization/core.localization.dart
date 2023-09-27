import 'package:bluecore/core/localization/core.language.dart';
import 'package:bluecore/core/localization/core.language_code.dart';

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
      LanguageCodes.sendPasswordSuccessTextInfo.toString():
          'Một liên kết đặt lại mật khẩu được gửi đến địa chỉ email của bạn. Vui lòng kiểm tra email của bạn.',
      LanguageCodes.notificationTextInfo.toString(): 'Thông báo',
      LanguageCodes.sendTextInfo.toString(): 'Đã gửi',
      LanguageCodes.ignoreTextInfo.toString(): 'Đã hiểu',
      LanguageCodes.playgroundTextInfo.toString(): 'Kiểm tra',
      LanguageCodes.blueCoreBotTextInfo.toString(): 'Bot bluecore',
      LanguageCodes.customerIdTextInfo.toString(): 'Mã khách hàng',
      LanguageCodes.enterContentMessageChatTextInfo.toString():
          'Nhập nội dung tin nhắn ở đây',
      LanguageCodes.historiesMessageChatTextInfo.toString(): 'Lịch sử',
      LanguageCodes.supportedCustomerMessageChatTextInfo.toString():
          'Hệ thống hỗ trợ khách hàng',
      LanguageCodes.emptyHistoriesMessageChatTextInfo.toString():
          'Lịch sử trống',
      LanguageCodes.removeAllMessageChatTextInfo.toString(): 'Xoá tất cả',
      LanguageCodes.logoutTextInfo.toString(): 'Đăng xuất',
      LanguageCodes.removeSingleChatTextInfo.toString(): 'Xoá trò chuyện',
      LanguageCodes.changeNameChatTextInfo.toString(): 'Sửa tên',
      LanguageCodes.newChatTextInfo.toString(): 'Trò chuyện mới',
      LanguageCodes.respondingTextInfo.toString(): 'Đang phản hồi...',
      LanguageCodes.pleaseChooseChatIdTextInfo.toString():
          'Vui lòng chọn trò chuyện cần đổi tên',
      LanguageCodes.noNameChatIdTextInfo.toString(): 'Chưa đặt tên',
      LanguageCodes.errorServerTextInfo.toString():
          'Máy chủ không phản hồi vui lòng thử lại sau',
      LanguageCodes.isConfirmTextInfo.toString():
          'Thao tác này không thể hoàn tác! Bạn có muốn thực hiện?',
      LanguageCodes.isSureTextInfo.toString(): 'Đồng ý',
      LanguageCodes.isNotSureTextInfo.toString(): 'Không',
      LanguageCodes.youSureLogoutTextInfo.toString():
          'Bạn có muốn đăng xuất không?',
    }
  };
  static String L(String key, {String locale = 'vi'}) {
    return _localizedValues[locale]![key] ??
        _localizedValues[locale]![LanguageCodes.notfoundTextInfo.toString()]!;
  }
}
