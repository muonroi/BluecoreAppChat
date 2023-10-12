import 'package:bluecore/feature/accounts/data/models/model.authenticate.dart';
import 'package:bluecore/feature/accounts/data/services/services.account.dart';
import 'package:bluecore/shared/models/model.baseoutput.dart';

class AccountRepository {
  final String username;
  final String password;
  final serviceAccount = ServiceAccount();

  AccountRepository(this.username, this.password);

  Future<AuthenticateModel> signIn() =>
      serviceAccount.signIn(username, password);
  Future<BaseOutputModel> forgotPassword() =>
      serviceAccount.forgotPassword(username);
  Future<BaseOutputModel> changeLanguage(String code) =>
      serviceAccount.changeLanguage(code);
}
