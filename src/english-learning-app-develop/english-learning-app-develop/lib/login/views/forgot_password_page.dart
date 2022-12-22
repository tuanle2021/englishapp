import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/components/login_textfield.dart';
import 'package:learning_english_app/login/models/services/login_services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordFormState();
  }
}

class ForgotPasswordFormState extends State<ForgotPasswordPage> {
  final forgotPasswordFormKey = GlobalKey<FormState>();

  final emailTxtFieldKey = GlobalKey<FormFieldState>();

  final emailTxtFieldController = TextEditingController();
  final service = LoginService();

  final RoundedLoadingButtonController resetPasswordButtonController =
      RoundedLoadingButtonController();

  var errorMessage = "";

  var isSendSuccess = false;
  var isNotValid = false;

  final focusEmailTxtField = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusEmailTxtField.addListener(() {
      if (!focusEmailTxtField.hasFocus) {
        emailTxtFieldKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context).resetPassword)
            .customAppBar(context),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            bottom: false,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(
                  horizontal: PaddingConstants.extraLarge,
                  vertical: PaddingConstants.med),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/images/forgotpass.png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(AppLocalizations.of(context).resetPasswordDescription,
                        style: Theme.of(context).textTheme.bodyLarge),
                    Form(
                        key: forgotPasswordFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: PaddingConstants.med,
                            ),
                            LoginTextField(
                                iconData: Icons.lock,
                                key: Key("Email"),
                                textFieldKey: emailTxtFieldKey,
                                focusNode: focusEmailTxtField,
                                textEditingController: emailTxtFieldController,
                                isPassword: false,
                                textLabel: AppLocalizations.of(context).email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .errorEmptyEmail;
                                  }
                                  if (!value.isValidEmail()) {
                                    return AppLocalizations.of(context)
                                        .errorInvalidEmail;
                                  }
                                  return null;
                                },
                                onChanged: (text) {}),
                            SizedBox(
                              height: PaddingConstants.med,
                            ),
                            Center(
                                child: LoginButton(
                              roundedLoadingButtonController:
                                  resetPasswordButtonController,
                              buttonLabel:
                                  AppLocalizations.of(context).sendRequest,
                              onPressed: () {
                                if (forgotPasswordFormKey.currentState !=
                                        null &&
                                    forgotPasswordFormKey.currentState!
                                        .validate()) {
                                  //Dang ky

                                  FocusManager.instance.primaryFocus?.unfocus();

                                  service.forgotPassword(
                                      emailTxtFieldController.text, (result) {
                                    setState(() {
                                      var resultMap =
                                          result as Map<String, dynamic>;
                                      if (resultMap["validEmail"] as bool ==
                                          true) {
                                        setState(() {
                                          resetPasswordButtonController.reset();
                                          isSendSuccess = true;
                                          isNotValid = false;
                                        });
                                      } else if (resultMap["validEmail"]
                                              as bool ==
                                          false) {
                                        setState(() {
                                          resetPasswordButtonController.reset();
                                          isNotValid = true;
                                          isSendSuccess = false;
                                          errorMessage =
                                              AppLocalizations.of(context)
                                                  .emailNotBeenFound;
                                        });
                                      } else {
                                        setState(() {
                                          resetPasswordButtonController.reset();
                                          isNotValid = true;
                                          isSendSuccess = false;
                                          errorMessage = AppLocalizations.of(
                                                  context)
                                              .somethingwentwrongpleasetryagainlater;
                                        });
                                      }
                                    });
                                  }, (error) {
                                    resetPasswordButtonController.reset();
                                    ToastController.showError(
                                        AppLocalizations.of(context)
                                            .somethingwentwrongpleasetryagainlater,
                                        context);
                                  });
                                } else {
                                  //Fail
                                  resetPasswordButtonController.reset();
                                }

                                // Dang ky
                              },
                            )),
                            SizedBox(
                              height: PaddingConstants.large,
                            ),
                            (isSendSuccess == true)
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.greenAccent,
                                    ),
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Icon(
                                                  Icons.check,
                                                  size: 24,
                                                )),
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)
                                                    .forgotPasswordSendSuccess,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                                : SizedBox.shrink(),
                            (isNotValid == true)
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                                child: Icon(Icons.error,
                                                    size: 24,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onError),
                                                alignment: PlaceholderAlignment
                                                    .middle),
                                            TextSpan(
                                                text: errorMessage,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onError)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                                : SizedBox.shrink()
                          ],
                        )),
                  ]),
            )));
  }
}
