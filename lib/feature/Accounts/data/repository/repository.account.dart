import 'package:bluecore_appchat/feature/Accounts/data/models/model.authenticate.dart';
import 'package:bluecore_appchat/feature/Accounts/data/services/services.account.dart';
import 'package:bluecore_appchat/shared/models/model.baseoutput.dart';

class AccountRepository {
  final String username;
  final String password;
  final serviceAccount = ServiceAccount();

  AccountRepository(this.username, this.password);

  Future<AuthenticateModel> signIn() =>
      serviceAccount.signIn(username, password);
  Future<BaseOutputModel> forgotPassword() =>
      serviceAccount.forgotPassword(username);
}
