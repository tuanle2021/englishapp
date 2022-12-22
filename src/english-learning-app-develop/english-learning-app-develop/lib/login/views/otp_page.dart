import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/login/models/dataset/token_dataset.dart';
import 'package:learning_english_app/login/models/services/login_services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class OtpPage extends StatefulWidget {
  OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

final activateButtonController = RoundedLoadingButtonController();

class _OtpPageState extends State<OtpPage> {
  final service = LoginService();
  final tokenDao = StorageController.database?.tokenDao;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context).activatedAccount,
                isNotHasBackButton: true)
            .customAppBar(context),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.background,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).otpSend +
                      (args["email"] as String),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: PaddingConstants.large),
                Text(
                  AppLocalizations.of(context).expired,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: PaddingConstants.large),
                OtpTextField(
                  numberOfFields: 5,
                  borderColor: Theme.of(context).colorScheme.primary,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    service.veriyActivateCode(
                        code: verificationCode,
                        email: args["email"] as String,
                        password: args["password"] as String,
                        success: (result) {
                          var resultMap = result as Map<String, dynamic>;
                          if (resultMap["success"] == true) {
                            DeviceInfo.getDeviceId().then((deviceId) {
                              tokenDao?.deleteRToken("REFRESH_TOKEN");
                              tokenDao?.deleteRToken("ACCESS_TOKEN");
                              var accessToken = new TokenDataset(
                                  deviceId: deviceId!,
                                  token: resultMap["accessToken"] as String,
                                  expiryDate: "",
                                  tokenType: "ACCESS_TOKEN");
                              tokenDao?.insertToken(accessToken);
                              var refreshTokenData = resultMap["refreshToken"]
                                  as Map<String, dynamic>;
                              var refreshToken = new TokenDataset(
                                  deviceId: deviceId,
                                  token: refreshTokenData["refreshToken"]
                                      as String,
                                  expiryDate:
                                      refreshTokenData["expiry"].toString(),
                                  tokenType: "REFRESH_TOKEN");
                              tokenDao?.insertToken(refreshToken);
                              Navigator.of(context).pushNamed("/home");
                            });
                          }
                        },
                        failure: (error) {
                          var errors = error as Map<String, dynamic>;
                          if (errors["notCorrect"] as bool == true ||
                              errors["notFound"] as bool == true) {
                            ToastController.showError(
                                errors["error"].toString(), context);
                          } else {
                            ToastController.showError(
                                AppLocalizations.of(context)
                                    .somethingwentwrongpleasetryagainlater,
                                context);
                          }
                        });
                  }, // end onSubmit
                ),
                SizedBox(height: PaddingConstants.large),
                LoginButton(
                    onPressed: () {},
                    buttonLabel: AppLocalizations.of(context).activate,
                    roundedLoadingButtonController: activateButtonController),
                SizedBox(
                  height: PaddingConstants.large,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).notreceivecode,
                        style: Theme.of(context).textTheme.bodyLarge),
                    GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppLocalizations.of(context).resend,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        )),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
