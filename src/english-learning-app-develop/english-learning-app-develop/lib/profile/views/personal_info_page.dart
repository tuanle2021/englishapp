import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:learning_english_app/common/controller/social_login_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/components/custom_textfield.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';

class PersonalInfoPage extends StatefulWidget {
  final ProfileService? profileService;
  PersonalInfoPage({required this.profileService});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  UserProfileDataset? profileDataset;
  _PersonalInfoPageState();
  bool notChangeInfo = true;

  bool isUsingEmail = false;
  bool isLinkedGoogle = false;
  bool isLinkedFacebook = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profileDataset = UserProfileDataset(id: "");
    profileDataset?.lastName =
        widget.profileService?.userProfile.lastName ?? "";
    profileDataset?.firstName =
        widget.profileService?.userProfile.firstName ?? "";
    profileDataset?.email = widget.profileService?.userProfile.email ?? "";
    profileDataset?.photoUrl =
        widget.profileService?.userProfile.photoUrl ?? "";

    profileDataset?.isSharedData =
        widget.profileService?.userProfile.isSharedData ?? false;

    profileDataset?.mainAuthStrategy =
        widget.profileService?.userProfile.mainAuthStrategy;

    if (widget.profileService?.userProfile.authStrategy?.contains("Facebook") !=
        null) {
      isLinkedFacebook =
          widget.profileService!.userProfile.authStrategy!.contains("Facebook");
    }
    if (widget.profileService?.userProfile.authStrategy?.contains("Google") !=
        null) {
      isLinkedGoogle =
          widget.profileService!.userProfile.authStrategy!.contains("Google");
    }
    if (widget.profileService?.userProfile.authStrategy?.contains("local") !=
        null) {
      isUsingEmail =
          widget.profileService!.userProfile.authStrategy!.contains("local");
    }
  }

  void updateLinkBool() {
    if (widget.profileService?.userProfile.authStrategy?.contains("Facebook") !=
        null) {
      isLinkedFacebook =
          widget.profileService!.userProfile.authStrategy!.contains("Facebook");
    }
    if (widget.profileService?.userProfile.authStrategy?.contains("Google") !=
        null) {
      isLinkedGoogle =
          widget.profileService!.userProfile.authStrategy!.contains("Google");
    }
    if (widget.profileService?.userProfile.authStrategy?.contains("local") !=
        null) {
      isUsingEmail =
          widget.profileService!.userProfile.authStrategy!.contains("local");
    }
  }

  void handleOnLink(String linkAccount) async {
    final result = await SocialLoginController.facebookAuth.login();
    DialogController.showLoadingDialog(context: context);
    if (result.accessToken != null) {
      widget.profileService?.linkingAccount(
          linkAccount: linkAccount,
          accessToken: result.accessToken!.token,
          success: (result) {
            var resultMap = result as Map<String, dynamic>;
            if (resultMap["success"] as bool == true) {
              resultMap["userProfile"]["id"] = resultMap["userProfile"]["_id"];
              StorageController.database?.userProfileDao.updateUserProfile(
                  UserProfileDataset.fromJson(
                      resultMap["userProfile"] as Map<String, dynamic>));
              widget.profileService?.userProfile = UserProfileDataset.fromJson(
                  resultMap["userProfile"] as Map<String, dynamic>);
              this.profileDataset = UserProfileDataset.fromJson(
                  resultMap["userProfile"] as Map<String, dynamic>);
              updateLinkBool();
              DialogController.dismisDialog();
              setState(() {});
            } else {
              DialogController.dismisDialog();
              ToastController.showInfo(
                  AppLocalizations.of(context).accountLinkAlready, context);
            }
          },
          failure: (error) {
            DialogController.dismisDialog();
            ToastController.showError(
                AppLocalizations.of(context)
                    .somethingwentwrongpleasetryagainlater,
                context);
          });
    } else {
      DialogController.dismisDialog();
    }
  }

  void handleOffLink(String linkAccount) async {
    DialogController.showWarningDialog(
        title: AppLocalizations.of(context).unlinkAccount,
        context: context,
        actionNegative: () {
          DialogController.dismisDialog();
        },
        actionPositive: () {
          var string =
              widget.profileService?.userProfile.authStrategy?.split(",");
          string!.removeWhere((element) => element == linkAccount);
          var oldProfile = widget.profileService?.userProfile;
          widget.profileService?.userProfile.authStrategy = string.join(",");
          if (linkAccount == "Google") {
            widget.profileService?.userProfile.googleId = "";
          } else if (linkAccount == "Facebook") {
            widget.profileService?.userProfile.facebookId = "";
          }
          widget.profileService?.updateProfile(
              userProfileDataset: widget.profileService!.userProfile,
              success: (result) {
                this.profileDataset = widget.profileService?.userProfile;
                StorageController.database?.userProfileDao
                    .updateUserProfile(widget.profileService!.userProfile);
                updateLinkBool();
                setState(() {});
                DialogController.dismisDialog();
              },
              failure: (error) {
                DialogController.dismisDialog();
                ToastController.showError(
                    AppLocalizations.of(context)
                        .somethingwentwrongpleasetryagainlater,
                    context);
                widget.profileService!.userProfile = oldProfile!;
              });
        },
        buttonNamePositive: AppLocalizations.of(context).yes,
        buttonNameNegative: AppLocalizations.of(context).no);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context).personalInfo,
                onPressed: () {
          Navigator.of(context).pop();
        },
                actions: CupertinoButton(
                    child: Text(
                      AppLocalizations.of(context).saveButton,
                      style: (notChangeInfo)
                          ? Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Color.fromARGB(210, 116, 116, 128))
                          : Theme.of(context).textTheme.labelLarge!.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                    ),
                    onPressed: notChangeInfo
                        ? null
                        : () {
                            widget.profileService?.userProfile.email =
                                profileDataset?.email;
                            widget.profileService?.userProfile.firstName =
                                profileDataset?.firstName;
                            widget.profileService?.userProfile.lastName =
                                profileDataset?.lastName;
                            widget.profileService?.userProfile.isSharedData =
                                profileDataset?.isSharedData;
                            widget.profileService?.updateProfile(
                                userProfileDataset:
                                    widget.profileService!.userProfile!,
                                success: (result) {
                                  print(result);
                                  var resultMap =
                                      result as Map<String, dynamic>;
                                  if (resultMap["success"] as bool == true) {
                                    resultMap["userProfile"]["id"] =
                                        resultMap["userProfile"]["_id"];
                                    StorageController.database?.userProfileDao
                                        .updateUserProfile(
                                            UserProfileDataset.fromJson(
                                                resultMap["userProfile"]
                                                    as Map<String, dynamic>));
                                    widget.profileService?.userProfile =
                                        UserProfileDataset.fromJson(
                                            resultMap["userProfile"]
                                                as Map<String, dynamic>);
                                    this.profileDataset =
                                        UserProfileDataset.fromJson(
                                            resultMap["userProfile"]
                                                as Map<String, dynamic>);
                                    updateLinkBool();
                                    DialogController.dismisDialog();
                                    setState(() {});
                                  } else {
                                    DialogController.dismisDialog();
                                    ToastController.showInfo(
                                        AppLocalizations.of(context)
                                            .accountLinkAlready,
                                        context);
                                  }
                                  // write code here
                                  notChangeInfo = true;

                                  setState(() {});
                                },
                                failure: (value) {});
                          }))
            .customAppBar(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: PaddingConstants.large,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            AppLocalizations.of(context).firstname,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        CustomTextField(
                            initialValue: profileDataset?.firstName ?? "",
                            customPadding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                            customWidth:
                                MediaQuery.of(context).size.width * 0.4,
                            textLabel: AppLocalizations.of(context).firstname,
                            onChanged: (value) {
                              profileDataset?.firstName = value;
                              setState(() {
                                if (profileDataset?.firstName ==
                                        widget.profileService?.userProfile
                                            .firstName &&
                                    profileDataset?.lastName ==
                                        widget.profileService?.userProfile
                                            .lastName &&
                                    profileDataset?.email ==
                                        widget.profileService?.userProfile
                                            .email) {
                                  notChangeInfo = true;
                                  return;
                                }
                                notChangeInfo = false;
                              });
                            },
                            isPassword: false),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppLocalizations.of(context).lastname,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        CustomTextField(
                          initialValue: profileDataset?.lastName ?? "",
                          customPadding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          customWidth: MediaQuery.of(context).size.width * 0.6,
                          textLabel: AppLocalizations.of(context).lastname,
                          onChanged: (value) {
                            profileDataset?.lastName = value;
                            setState(() {
                              if (profileDataset?.firstName ==
                                      widget.profileService?.userProfile
                                          .firstName &&
                                  profileDataset?.lastName ==
                                      widget.profileService?.userProfile
                                          .lastName &&
                                  profileDataset?.email ==
                                      widget
                                          .profileService?.userProfile.email) {
                                notChangeInfo = true;
                                return;
                              }
                              notChangeInfo = false;
                            });
                          },
                          isPassword: false,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: PaddingConstants.large,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Email",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                CustomTextField(
                    textLabel: "Email",
                    onChanged: (value) {},
                    disable: true,
                    initialValue: widget.profileService?.userProfile.email,
                    customPadding: EdgeInsets.symmetric(horizontal: 20)),
                SizedBox(
                  height: PaddingConstants.extraLarge,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    AppLocalizations.of(context).linkedAccount,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title: Text("Google"),
                  leading: Image.asset("assets/images/search.png",
                      width: 20, height: 20),
                  trailing: (Theme.of(context).platform != TargetPlatform.iOS)
                      ? Switch(
                          value: isLinkedGoogle,
                          onChanged:
                              profileDataset?.mainAuthStrategy != "Google"
                                  ? (value) async {
                                      if (value == true) {
                                        handleOnLink("Google");
                                      } else {
                                        handleOffLink("Google");
                                      }
                                    }
                                  : null,
                        )
                      : CupertinoSwitch(
                          value: isLinkedGoogle,
                          onChanged:
                              profileDataset?.mainAuthStrategy != "Google"
                                  ? (value) async {
                                      if (value == true) {
                                        handleOnLink("Google");
                                      } else {
                                        handleOffLink("Google");
                                      }
                                    }
                                  : null,
                        ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title: Text("Facebook"),
                  leading: Icon(FontAwesome.facebook),
                  trailing: (Theme.of(context).platform != TargetPlatform.iOS)
                      ? Switch(
                          value: isLinkedFacebook,
                          onChanged:
                              profileDataset?.mainAuthStrategy != "Facebook"
                                  ? (value) async {
                                      if (value == true) {
                                        handleOnLink("Facebook");
                                      } else {
                                        handleOffLink("Facebook");
                                      }
                                    }
                                  : null,
                        )
                      : CupertinoSwitch(
                          value: isLinkedFacebook,
                          onChanged:
                              profileDataset?.mainAuthStrategy != "Facebook"
                                  ? (value) async {
                                      if (value == true) {
                                        handleOnLink("Facebook");
                                      } else {
                                        handleOffLink("Facebook");
                                      }
                                    }
                                  : null,
                        ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title:
                      Text(AppLocalizations.of(context).leaderboard_permisson),
                  leading: Icon(FontAwesome.trophy),
                  trailing: (Theme.of(context).platform != TargetPlatform.iOS)
                      ? Switch(
                          value: profileDataset?.isSharedData ?? false,
                          onChanged: (value) {
                            setState(() {
                              profileDataset?.isSharedData = value;
                              setState(() {
                                if (profileDataset?.isSharedData ==
                                    widget.profileService?.userProfile
                                        .isSharedData) {
                                  notChangeInfo = true;
                                  return;
                                }
                                notChangeInfo = false;
                              });
                            });
                          },
                        )
                      : CupertinoSwitch(
                          value: profileDataset?.isSharedData ?? false,
                          onChanged: (value) {
                            profileDataset?.isSharedData = value;
                            setState(() {
                              if (profileDataset?.isSharedData ==
                                  widget.profileService?.userProfile
                                      .isSharedData) {
                                notChangeInfo = true;
                                return;
                              }
                              notChangeInfo = false;
                            });
                          },
                        ),
                ),
              ],
            )),
          ),
        ));
  }
}
