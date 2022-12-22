import 'dart:async';

import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:learning_english_app/common/controller/social_login_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:learning_english_app/common/nagivation_service.dart';
import 'package:learning_english_app/common/word_service.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/login_button.dart';
import 'package:learning_english_app/components/login_textfield.dart';
import 'package:learning_english_app/favourite/models/dao/user_favorite_dao.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';
import 'package:learning_english_app/login/models/dataset/token_dataset.dart';
import 'package:learning_english_app/login/models/services/login_services.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../common/extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();
  final emailTxtFieldKey = GlobalKey<FormFieldState>();
  final passwordTxtFieldKey = GlobalKey<FormFieldState>();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final focusEmailTxtField = FocusNode();
  final focusPasswordTxtField = FocusNode();
  final tokenDao = StorageController.database?.tokenDao;
  bool disableTextField = false;
  final RoundedLoadingButtonController loginButtonController =
      RoundedLoadingButtonController();

  final service = LoginService();
  final wordService = WordService();
  late StreamSubscription<ConnectivityResult> subscription;

  void fetchCommonData(result) async {
    // handle token
    var resultMap = result as Map<String, dynamic>;
    tokenDao?.deleteRToken("REFRESH_TOKEN");
    tokenDao?.deleteRToken("ACCESS_TOKEN");
    var accessTokenValue = resultMap["accessToken"] as String;
    var refreshTokenValue = resultMap["refreshToken"] as Map<String, dynamic>;
    var accessToken = new TokenDataset(
        deviceId: DeviceInfo.deviceID,
        token: accessTokenValue,
        expiryDate: "",
        tokenType: "ACCESS_TOKEN");
    var refreshToken = new TokenDataset(
        deviceId: DeviceInfo.deviceID,
        token: refreshTokenValue["refreshToken"],
        expiryDate: refreshTokenValue["expiry"].toString(),
        tokenType: "REFRESH_TOKEN");

    //handle Profile
    var profileMap = result["userProfile"] as Map<String, dynamic>;
    profileMap["id"] = profileMap["_id"];
    var userProfile = UserProfileDataset.fromJson(profileMap);
    List<CategoryUserDataset> categoryUserDatasetList = [];
    var categoryUserList = result["category_user"] as List<dynamic>;
    var categoryUserLength = categoryUserList.length;
    for (int i = 0; i < categoryUserLength; i++) {
      var map = categoryUserList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      categoryUserDatasetList.add(CategoryUserDataset.fromJson(map));
    }

    List<LessonUserScoreDataset> lessonUserScoreDatasetList = [];
    var lessonUserScoreList = result["lesson_user_score"] as List<dynamic>;
    var lessonUserScoreLength = lessonUserScoreList.length;
    for (int i = 0; i < lessonUserScoreLength; i++) {
      var map = lessonUserScoreList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      lessonUserScoreDatasetList.add(LessonUserScoreDataset.fromJson(map));
    }
    List<UserFavouriteDataset> userFavouriteDatasetList = [];
    var userFavouriteList = result["user_favourite"] as List<dynamic>;
    var userFavouriteLength = userFavouriteList.length;
    for (int i = 0; i < userFavouriteLength; i++) {
      var map = userFavouriteList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      userFavouriteDatasetList.add(UserFavouriteDataset.fromJson(map));
    }

    List<LessonUserDataset> lessonUserDatasetList = [];
    var lessonUserList = result["lesson_user"] as List<dynamic>;
    var lessonUserLength = lessonUserList.length;
    for (int i = 0; i < lessonUserLength; i++) {
      var map = lessonUserList[i] as Map<String, dynamic>;
      map.parseApiResponse();
      lessonUserDatasetList.add(LessonUserDataset.fromJson(map));
    }

    final futureGroup = FutureGroup();
    futureGroup.add(tokenDao!.insertToken(accessToken));
    futureGroup.add(tokenDao!.insertToken(refreshToken));
    futureGroup.add(StorageController.database!.userProfileDao
        .insertUserProfile(userProfile));
    futureGroup.add(StorageController.database!.categoryUserDao
        .insertListCategoryTransaction(categoryUserDatasetList));
    futureGroup.add(StorageController.database!.userFavouriteDao
        .insertListUserFavouriteTransaction(userFavouriteDatasetList));

    futureGroup.add(StorageController.database!.lessonUserDao
        .insertListLessonTransaction(lessonUserDatasetList));
    futureGroup.add(StorageController.database!.lessonUserScoreDao
        .insertLessonUserScoreTransaction(lessonUserScoreDatasetList));
    futureGroup.close();

    futureGroup.future.then((value) {
      StorageController.setCurrentUserId(userProfile.id ?? "");
      Navigator.of(context).pop();
      NavigationService.navigatorKey.currentState!
          .pushNamedAndRemoveUntil('/home', (route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
    });
    focusEmailTxtField.addListener(() {
      if (!focusEmailTxtField.hasFocus) {
        emailTxtFieldKey.currentState!.validate();
      }
    });

    focusPasswordTxtField.addListener(() {
      if (!focusPasswordTxtField.hasFocus) {
        passwordTxtFieldKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var brightness = Theme.of(context).brightness;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(AppLocalizations.of(context).signInText)
            .customAppBar(context),
        body: SafeArea(
          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: PaddingConstants.extraLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: PaddingConstants.small),
                    child: Image.asset("assets/images/home.png",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: loginFormKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            LoginTextField(
                              disable: disableTextField,
                              textEditingController: emailTextEditingController,
                              iconData: Icons.email,
                              key: Key("Email"),
                              focusNode: focusEmailTxtField,
                              isPassword: false,
                              textFieldKey: emailTxtFieldKey,
                              textLabel: AppLocalizations.of(context).email,
                              onChanged: (text) {},
                              validator: (value) {
                                if (value != null && value.isValidEmail()) {
                                  return null;
                                }
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)
                                      .errorEmptyEmail;
                                }
                                return AppLocalizations.of(context)
                                    .errorInvalidEmail;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: PaddingConstants.small),
                              child: LoginTextField(
                                disable: disableTextField,
                                isPassword: true,
                                textEditingController:
                                    passwordTextEditingController,
                                focusNode: focusPasswordTxtField,
                                textFieldKey: passwordTxtFieldKey,
                                iconData: Icons.lock,
                                key: Key("Password"),
                                textLabel:
                                    AppLocalizations.of(context).password,
                                onChanged: (text) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .errorEmptyPassword;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LoginButton(
                            roundedLoadingButtonController:
                                loginButtonController,
                            padding: EdgeInsets.symmetric(
                                vertical: PaddingConstants.small),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                this.disableTextField = true;
                              });
                              if (loginFormKey.currentState!.validate()) {
                                DialogController.showLoadingDialog(
                                    context: context);
                                service.signIn(emailTextEditingController.text,
                                    passwordTextEditingController.text,
                                    (result) {
                                  var resultMap =
                                      result as Map<String, dynamic>;

                                  if (resultMap["success"] as bool == true) {
                                    if (resultMap["isActivated"] as bool ==
                                        false) {
                                      service.sendActivateCode(
                                          emailTextEditingController.text,
                                          passwordTextEditingController.text,
                                          (result) {
                                        var resultMap =
                                            result as Map<String, Object>;

                                        if (resultMap["success"] as bool ==
                                            true) {
                                          setState(() {
                                            this.disableTextField = false;
                                          });
                                          DialogController.dismisDialog();
                                          Map<String, String> param = Map();
                                          param["email"] =
                                              emailTextEditingController.text;
                                          param["password"] =
                                              passwordTextEditingController
                                                  .text;
                                          Navigator.of(context).pushNamed(
                                              "/otp",
                                              arguments: param);
                                          loginButtonController.reset();

                                          return;
                                        }
                                      }, (error) {
                                        DialogController.dismisDialog();
                                        loginButtonController.reset();
                                        setState(() {
                                          this.disableTextField = false;
                                        });
                                        ToastController.showError(
                                            AppLocalizations.of(context)
                                                .somethingwentwrongpleasetryagainlater,
                                            context);
                                      });
                                      return;
                                    }
                                    loginButtonController.reset();
                                    fetchCommonData(result);
                                  }
                                }, (error) {
                                  DialogController.dismisDialog();
                                  var errorMap = error as Map<String, dynamic>;
                                  loginButtonController.reset();
                                  setState(() {
                                    this.disableTextField = false;
                                  });
                                  if (error == null) {
                                    ToastController.showError(
                                        AppLocalizations.of(context)
                                            .invalidCredentialLoginError,
                                        context);
                                  } else {
                                    ToastController.showError(
                                        errorMap["error"] as String, context);
                                  }
                                });
                              } else {
                                loginButtonController.reset();
                                setState(() {
                                  this.disableTextField = false;
                                });
                              }
                            },
                            buttonLabel:
                                AppLocalizations.of(context).signInText),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/forgot_password");
                                },
                                child: Text(
                                  AppLocalizations.of(context).forgotPassword,
                                  style: Theme.of(context).textTheme.labelLarge,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: PaddingConstants.small),
                            child: Text(
                                AppLocalizations.of(context).orLoginWith,
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await SocialLoginController
                                .facebookAuth
                                .login();
                            if (result.accessToken != null) {
                              DialogController.showLoadingDialog(
                                  context: context);
                              service.signInWithFaceBook(
                                  accessToken: result.accessToken!.token,
                                  success: (result) {
                                    fetchCommonData(result);
                                  },
                                  failure: (error) {
                                    EasyLoading.dismiss();
                                    var errorMap =
                                        error as Map<String, dynamic>;
                                    ToastController.showError(
                                        error["error"], context);
                                  });
                            } else {}
                          },
                          icon: Icon(FlutterIcons.facebook_f_faw),
                          label: Text(
                            AppLocalizations.of(context).loginWithFacebook,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: textTheme.labelLarge!.fontSize,
                                fontWeight: textTheme.labelLarge!.fontWeight),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(350, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            primary: Color(0xff1877F2),
                            elevation: 2,
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            SocialLoginController.googleSignIn
                                .signIn()
                                .then((googleAccount) => {
                                      if (googleAccount != null)
                                        {
                                          DialogController.showLoadingDialog(
                                              context: context),
                                          googleAccount.authentication
                                              .then((value) => {
                                                    service.signInWithGoogle(
                                                        accessToken:
                                                            value.accessToken!,
                                                        success: (result) {
                                                          fetchCommonData(
                                                              result);
                                                        },
                                                        failure: (error) {
                                                          DialogController
                                                              .dismisDialog();
                                                          var errorMap = error
                                                              as Map<String,
                                                                  dynamic>;
                                                          ToastController
                                                              .showError(
                                                                  error[
                                                                      "error"],
                                                                  context);
                                                        })
                                                  })
                                        }
                                      else
                                        {}
                                    });
                          },
                          icon: Image.asset("assets/images/search.png",
                              width: 20, height: 20),
                          label: Text(
                            AppLocalizations.of(context).loginWithGoogle,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: textTheme.labelLarge!.fontSize,
                                fontWeight: textTheme.labelLarge!.fontWeight),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(350, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            primary: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: PaddingConstants.large),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    AppLocalizations.of(context)
                                        .signUpDescription,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                GestureDetector(
                                    onTap: () => {
                                          loginFormKey.currentState!.reset(),
                                          Navigator.of(context)
                                              .pushNamed('/sign_up')
                                        },
                                    child: Text(
                                      AppLocalizations.of(context).signUpText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ))
                              ],
                            )),
                        SizedBox(
                          height: PaddingConstants.large,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
