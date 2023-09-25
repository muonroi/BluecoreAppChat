import 'package:bluecore_appchat/core/localization/core.language_code.dart';
import 'package:bluecore_appchat/feature/Accounts/data/repository/repository.account.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.color.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.dart';
import 'package:bluecore_appchat/shared/settings/shared.settings.font.dart';
import 'package:bluecore_appchat/shared/widgets/buttons/shared.widget.button.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    _usernameController = TextEditingController();

    super.initState();
  }

  final bool ss = true;
  late TextEditingController _usernameController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    L(LanguageCodes.forgotPasswordTextInfo.toString()),
                    style: FontsGlobal.h4,
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  L(LanguageCodes.forgotPasswordMoreInfoTextInfo.toString()),
                  style: FontsGlobal.h6,
                ),
              ),
              SizedBox(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    width:
                        getPercentageOfDevice(context, expectWidth: 130).width,
                    child: ButtonGlobal(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsGlobal.whiteColor,
                      ),
                      text: L(LanguageCodes.backInfoTextInfo.toString()),
                      textStyle: FontsGlobal.h5
                          .copyWith(color: ColorsGlobal.textColor),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    width:
                        getPercentageOfDevice(context, expectWidth: 120).width,
                    child: ButtonGlobal(
                      onPressed: () async {
                        var accountRepository =
                            AccountRepository(_usernameController.text, "");
                        var result = await accountRepository.forgotPassword();
                        if (result.success == true) {
                          if (mounted) {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text(
                                      L(LanguageCodes.notificationTextInfo
                                          .toString()),
                                      style: FontsGlobal.h3,
                                    ),
                                    content: Text(
                                      L(LanguageCodes
                                          .sendPasswordSuccessTextInfo
                                          .toString()),
                                      style: FontsGlobal.h5,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color: ColorsGlobal.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: Text(
                                              L(LanguageCodes.ignoreTextInfo
                                                  .toString()),
                                              style: FontsGlobal.h5.copyWith(
                                                  color:
                                                      ColorsGlobal.whiteColor)),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsGlobal.mainColor,
                      ),
                      text: L(LanguageCodes.submitTextInfo.toString()),
                      textStyle: FontsGlobal.h5
                          .copyWith(color: ColorsGlobal.whiteColor),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
