import 'package:bluecore_appchat/core/localization/core.language_code.dart';
import 'package:bluecore_appchat/feature/Accounts/data/repository/repository.account.dart';
import 'package:bluecore_appchat/feature/Accounts/presentation/pages/account.forgot.password.dart';
import 'package:bluecore_appchat/feature/Accounts/settings/enums/enums.account.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.color.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.font.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _isShowLabelError = false;
    _rememberMe = false;
    _isVisibility = true;
    _initSharedPreferences().then((value) {
      _usernameController.text =
          _sharedPreferences.getString(AccountInfo.username.name) ?? "";
      _passwordController.text =
          _sharedPreferences.getString(AccountInfo.password.name) ?? "";
      _rememberMe =
          _sharedPreferences.getBool(AccountInfo.remember.name) ?? false;
    });
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  late SharedPreferences _sharedPreferences;
  late String username;
  late String password;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late bool _isShowLabelError;
  late bool _rememberMe;
  late bool _isVisibility;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: getPercentageOfDevice(context, expectHeight: 100).height,
            child: Image.asset(
              ImagesGlobal.mainLogo2x,
              width: getPercentageOfDevice(context, expectWidth: 220).width,
              height: getPercentageOfDevice(context, expectHeight: 60).height,
            ),
          ),
          _isShowLabelError
              ? Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    L(LanguageCodes.invalidAccountTextInfo.toString()),
                    style: FontsGlobal.h5
                        .copyWith(fontSize: 13, color: Colors.red),
                  ),
                )
              : Container(),
          SizedBox(
            height: getPercentageOfDevice(context, expectHeight: 100).height,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    icon: const Icon(
                      Icons.person,
                      color: ColorsGlobal.mainColor,
                    ),
                    border: const UnderlineInputBorder(),
                    labelText: L(LanguageCodes.usernameTextInfo.toString())),
              ),
            ),
          ),
          SizedBox(
            height: getPercentageOfDevice(context, expectHeight: 100).height,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isVisibility,
                decoration: InputDecoration(
                    icon: const Icon(
                      Icons.lock,
                      color: ColorsGlobal.mainColor,
                    ),
                    border: const UnderlineInputBorder(),
                    labelText: L(LanguageCodes.passwordTextInfo.toString()),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisibility = !_isVisibility;
                        });
                      },
                      icon: Icon(
                        _isVisibility ? Icons.visibility : Icons.visibility_off,
                        color: ColorsGlobal.mainColor,
                      ),
                    )),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getPercentageOfDevice(context, expectHeight: 70).height,
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text(
                      L(LanguageCodes.rememberTextInfo.toString()),
                      style: FontsGlobal.h5.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getPercentageOfDevice(context, expectHeight: 70).height,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Text(
                        L(LanguageCodes.forgotPasswordTextInfo.toString()),
                        style: FontsGlobal.h5.copyWith(
                            fontWeight: FontWeight.w900,
                            color: ColorsGlobal.mainColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: getPercentageOfDevice(context, expectHeight: 100).height!),
        child: FloatingActionButton(
            backgroundColor: ColorsGlobal.mainColor,
            onPressed: () async {
              var accountRepository = AccountRepository(
                  _usernameController.text, _passwordController.text);
              var accountInfo = await accountRepository.signIn();
              if (accountInfo.result == null) {
                setState(() {
                  _isShowLabelError = true;
                });
              } else {
                if (_rememberMe) {
                  _sharedPreferences.setString(
                      AccountInfo.username.name, _usernameController.text);
                  _sharedPreferences.setString(
                      AccountInfo.password.name, _passwordController.text);
                  _sharedPreferences.setBool(
                      AccountInfo.remember.name, _rememberMe);
                }
                _sharedPreferences.setString(
                    KeyToken.accessToken.name, accountInfo.result!.accessToken);
                _sharedPreferences.setString(KeyToken.refreshToken.name,
                    accountInfo.result!.refreshToken);
                _isShowLabelError = false;
                if (mounted) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Container()));
                }
              }
            },
            child: const Icon(
              Icons.login,
              color: ColorsGlobal.whiteColor,
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: RichText(
          text: TextSpan(
              text: L(LanguageCodes.noAccountTextInfo.toString()),
              style: FontsGlobal.h5,
              children: [
                TextSpan(
                    text: " ${L(LanguageCodes.initAccountTextInfo.toString())}",
                    style: FontsGlobal.h5.copyWith(
                        fontWeight: FontWeight.w900,
                        color: ColorsGlobal.mainColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()));
                      })
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
