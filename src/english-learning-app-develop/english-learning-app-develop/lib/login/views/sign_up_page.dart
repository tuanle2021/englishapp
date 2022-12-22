import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/components/login_textfield.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/login/models/services/login_services.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpPage> {
  final signUpFormKey = GlobalKey<FormState>();
  final firstNameTxtFieldKey = GlobalKey<FormFieldState>();
  final lastNameTxtFieldKey = GlobalKey<FormFieldState>();
  final emailTxtFieldKey = GlobalKey<FormFieldState>();
  final passwordTxtFieldKey = GlobalKey<FormFieldState>();
  final rePasswordTxtFieldKey = GlobalKey<FormFieldState>();

  final signUpButtonController = RoundedLoadingButtonController();

  bool validatePassword = false;
  final TextEditingController passwordTxtField = TextEditingController();
  final TextEditingController firstNameTxtField = TextEditingController();
  final TextEditingController lastNameTxtField = TextEditingController();
  final TextEditingController emailTxtField = TextEditingController();

  final focusPasswordTxtField = FocusNode();

  final focusRePasswordTxtField = FocusNode();
  final focusEmailTxtField = FocusNode();
  final focusFirstName = FocusNode();
  final focusLastName = FocusNode();

  final service = LoginService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusPasswordTxtField.addListener(() {
      if (!focusPasswordTxtField.hasFocus) {
        passwordTxtFieldKey.currentState?.validate();
      }
    });
    focusLastName.addListener(() {});

    focusFirstName.addListener(() {
      if (!focusFirstName.hasFocus) {
        firstNameTxtFieldKey.currentState?.validate();
      }
    });

    focusRePasswordTxtField.addListener(() {
      if (!focusRePasswordTxtField.hasFocus) {
        rePasswordTxtFieldKey.currentState?.validate();
      }
    });

    focusEmailTxtField.addListener(() {
      if (!focusEmailTxtField.hasFocus) {
        emailTxtFieldKey.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(AppLocalizations.of(context).createAccount)
            .customAppBar(context),
        body: SafeArea(
            bottom: false,
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                          "assets/images/login_illu(1).png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.15,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Form(
                          key: signUpFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  LoginTextField(
                                    customWidth:
                                        MediaQuery.of(context).size.width * 0.3,
                                    customPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    iconData: Icons.person,
                                    key: Key("Firstname"),
                                    focusNode: focusFirstName,
                                    textEditingController: firstNameTxtField,
                                    textFieldKey: Key("Firstname"),
                                    onChanged: (text) {},
                                    isPassword: false,
                                    validator: (value) {
                                      if (value != null && !value.isEmpty) {
                                        return null;
                                      }
                                      return AppLocalizations.of(context)
                                          .errorEmptyUserName;
                                    },
                                    textLabel:
                                        AppLocalizations.of(context).firstname,
                                  ),
                                  Expanded(
                                    child: LoginTextField(
                                      customWidth:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      iconData: null,
                                      key: Key("Lastname"),
                                      focusNode: focusLastName,
                                      textFieldKey: lastNameTxtFieldKey,
                                      textEditingController: lastNameTxtField,
                                      onChanged: (text) {},
                                      isPassword: false,
                                      validator: (value) {
                                        if (value != null && !value.isEmpty) {
                                          return null;
                                        }
                                        return AppLocalizations.of(context)
                                            .errorEmptyUserName;
                                      },
                                      textLabel:
                                          AppLocalizations.of(context).lastname,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: PaddingConstants.med,
                              ),
                              LoginTextField(
                                  iconData: Icons.email,
                                  key: Key("Email"),
                                  textFieldKey: emailTxtFieldKey,
                                  focusNode: focusEmailTxtField,
                                  isPassword: false,
                                  textEditingController: emailTxtField,
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
                              LoginTextField(
                                  iconData: Icons.lock,
                                  textEditingController: passwordTxtField,
                                  key: Key("Password"),
                                  textFieldKey: passwordTxtFieldKey,
                                  isPassword: true,
                                  focusNode: focusPasswordTxtField,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !value.isValidPassword()) {
                                      return AppLocalizations.of(context)
                                          .errorMiniumPassword;
                                    }
                                    return null;
                                  },
                                  textLabel:
                                      AppLocalizations.of(context).password,
                                  onChanged: (text) {}),
                              SizedBox(
                                height: PaddingConstants.med,
                              ),
                              LoginTextField(
                                  iconData: Icons.password,
                                  key: Key("rePassword"),
                                  textFieldKey: rePasswordTxtFieldKey,
                                  focusNode: focusRePasswordTxtField,
                                  validator: (value) {
                                    if (value == passwordTxtField.text) {
                                      return null;
                                    } else {
                                      return AppLocalizations.of(context)
                                          .errorPasswordMatch;
                                    }
                                  },
                                  isPassword: true,
                                  textLabel: AppLocalizations.of(context)
                                      .confirmPassword,
                                  onChanged: (text) {}),
                              SizedBox(
                                height: PaddingConstants.med,
                              ),
                              Center(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .signUpDescriptionText,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ),
                              SizedBox(
                                height: PaddingConstants.med,
                              ),
                              Center(
                                  child: LoginButton(
                                roundedLoadingButtonController:
                                    this.signUpButtonController,
                                buttonLabel:
                                    AppLocalizations.of(context).signUpText,
                                onPressed: () {
                                  if (signUpFormKey.currentState != null &&
                                      signUpFormKey.currentState!.validate()) {
                                    //Dang ky
                                    service.signUp(
                                        emailTxtField.text,
                                        firstNameTxtField.text,
                                        lastNameTxtField.text,
                                        passwordTxtField.text, (result) {
                                      Navigator.of(context).pop();
                                      signUpButtonController.success();
                                      ToastController.showSuccess(
                                          AppLocalizations.of(context)
                                              .signUpSuccess,
                                          context);
                                    }, (error) {
                                      var mapError = error as Map<String,dynamic>;
                                      signUpButtonController.reset();
                                      ToastController.showError(
                                          mapError["error"].toString(), context);
                                    });
                                  } else {
                                    //Fail
                                    signUpButtonController.reset();
                                  }

                                  // Dang ky
                                },
                              ))
                            ],
                          )),
                    ),
                  ]),
            )));
  }
}
