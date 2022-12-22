import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_english_app/common/controller/dialog_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/controller/toast_controller.dart';
import 'package:learning_english_app/components/custom_app_bar.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/services/profile_service.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final service = ProfileService();
 

  final imagePicker = ImagePicker();
  var storage = FirebaseStorage.instance;

  String displayName(String? firstName, String? lastName) {
    var first = firstName ?? "";
    var last = lastName ?? "";
    return first + " " + last;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StorageController.getCurrentUserId() != null &&
        StorageController.getCurrentUserId() != "") {
      StorageController.database?.userProfileDao
          .findUserProfile(StorageController.getCurrentUserId()!)
          .then((value) {
        if (value != null) {
          service.userProfile = value;
          setState(() {});
        }
      });
    } else {
      service.getUserProfile((result) {
        var resultMap = result as Map<String, dynamic>;
        setState(() {
          resultMap["user"]["id"] = resultMap["user"]["_id"];
          service.userProfile = UserProfileDataset.fromJson(
              resultMap["user"] as Map<String, dynamic>);

          StorageController.database?.userProfileDao
              .insertUserProfile(service.userProfile)
              .then((value) {
            StorageController.setCurrentUserId(service.userProfile.id!);
          });
        });
      }, (error) {});
    }

    
  }

  Widget buildShimmerHeader() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 15.0, right: 15.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      splashRadius: 20,
                      iconSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      )),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      )),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            subtitle: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            subtitle: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            subtitle: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.transparentAppBar().transparentAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              (service.userProfile.id != null)
                  ? _buildHeader(context)
                  : (Shimmer.fromColors(
                      child: buildShimmerHeader(),
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.white70)),
              _buildCollectionsRow(),
              buildFeedBack(),
              buildSignOut()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeedBack() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 5.0,
            color: Theme.of(context).colorScheme.surface,
            child: ListTileTap(
                onTap: () {
                Navigator.of(context).pushNamed('/feedback');
                }, title: AppLocalizations.of(context).feedback, leadingIcon: Icons.feedback)));
  }


  Widget buildSignOut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          color: Theme.of(context).colorScheme.surface,
          child: ListTileTap(
              onTap: () {
                DialogController.showWarningDialog(
                    title: AppLocalizations.of(context).signout,
                    message: AppLocalizations.of(context).areyousuretosignout,
                    context: context,
                    actionPositive: () {
                      service.signOut();
                    },
                    actionNegative: () {
                      DialogController.dismisDialog();
                    },
                    buttonNamePositive: AppLocalizations.of(context).yes,
                    buttonNameNegative: AppLocalizations.of(context).no);
              },
              title: AppLocalizations.of(context).signout,
              leadingIcon: Icons.logout)),
    );
  }

  Widget ListTileTap(
      {required VoidCallback onTap,
      required String title,
      IconData? leadingIcon}) {
    if (leadingIcon == null) {
      return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashColor: (Theme.of(context).brightness == Brightness.light)
            ? Colors.grey.shade300
            : Colors.grey.shade500,
        child: ListTile(
            horizontalTitleGap: 0,
            title: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      );
    }
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      splashColor: (Theme.of(context).brightness == Brightness.light)
          ? Colors.grey.shade300
          : Colors.grey.shade600,
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        horizontalTitleGap: 0,
        leading: Icon(leadingIcon),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget _buildCollectionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        color: Theme.of(context).colorScheme.surface,
        child: Column(children: [
          ListTileTap(
              onTap: () {}, title: AppLocalizations.of(context).settings),
          Divider(height: 0, indent: 0, thickness: 0, color: Colors.black54),
          ListTileTap(
              onTap: () {
                Navigator.of(context).pushNamed('/setting');
              },
              title: AppLocalizations.of(context).general,
              leadingIcon: Icons.settings),
          Divider(height: 0, indent: 0, thickness: 0, color: Colors.black54),
          ListTileTap(
              onTap: () {
                Navigator.of(context).pushNamed('/notification');
              },
              title: AppLocalizations.of(context).notifications,
              leadingIcon: Icons.notifications),
         
          
        ]),
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 30.0, left: 15.0, right: 15.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("/personal_info", arguments: service)
                            .then((value) {
                          setState(() {});
                        });
                      },
                      icon: Icon(Icons.edit),
                      splashRadius: 20,
                      iconSize: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    displayName(service.userProfile.firstName,
                        service.userProfile.lastName),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text((service.userProfile.email != "")
                      ? service.userProfile.email ?? ""
                      : ""),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "302",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Words learned".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "103",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Exercises done".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "120",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Hours Learning ".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          (service.userProfile.photoUrl != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      child: Stack(children: [
                        CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 100),
                            fadeOutDuration: Duration(milliseconds: 100),
                            imageUrl: service.userProfile.photoUrl!,
                            fit: BoxFit.fill,
                            imageBuilder: (context, imageProvider) => ClipOval(
                                  child: Image(
                                    image: imageProvider,
                                  ),
                                ),
                            errorWidget: (context, url, error) => Center(
                                  child: ClipOval(
                                    child: Text(
                                        service.userProfile.firstName
                                                ?.substring(0, 1) ??
                                            "",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                  ),
                                )),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? pickedFile = await imagePicker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  var croppedFile =
                                      await ImageCropper().cropImage(
                                          sourcePath: pickedFile.path,
                                          cropStyle: CropStyle.circle,
                                          androidUiSettings: AndroidUiSettings(
                                            toolbarTitle:
                                                AppLocalizations.of(context)
                                                    .cropper,
                                            toolbarColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            toolbarWidgetColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          iosUiSettings: IOSUiSettings(
                                            minimumAspectRatio: 1.0,
                                            title: AppLocalizations.of(context)
                                                .cropper,
                                            doneButtonTitle:
                                                AppLocalizations.of(context)
                                                    .doneButton,
                                            cancelButtonTitle:
                                                AppLocalizations.of(context)
                                                    .cancelButton,
                                          ));

                                  var path =
                                      "images/" + service.userProfile!.id!;
                                  if (croppedFile != null) {
                                    EasyLoading.show(
                                        maskType: EasyLoadingMaskType.black);
                                    TaskSnapshot snapshot = await storage
                                        .ref()
                                        .child(path)
                                        .putFile(croppedFile);
                                    if (snapshot.state == TaskState.error) {
                                      ToastController.showError(
                                          AppLocalizations.of(context)
                                              .avatarUpdateUnsuccess,
                                          context);
                                    } else if (snapshot.state ==
                                        TaskState.success) {
                                      final String downloadUrl =
                                          await snapshot.ref.getDownloadURL();
                                      service.userProfile.photoUrl =
                                          downloadUrl;
                                      service.updateProfile(
                                          userProfileDataset:
                                              service.userProfile,
                                          success: (result) {
                                            StorageController
                                                .database?.userProfileDao
                                                .updateUserProfile(
                                                    service.userProfile);
                                            setState(() {
                                              EasyLoading.dismiss();
                                            });
                                          },
                                          failure: (error) {
                                            EasyLoading.dismiss();
                                            ToastController.showError(
                                                AppLocalizations.of(context)
                                                    .avatarUpdateUnsuccess,
                                                context);
                                          });
                                    }
                                  }
                                }
                              },
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    Icons.image,
                                    size: 14,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ) // change this children
                                  ),
                            ))
                      ]),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      child: Stack(children: [
                        Center(
                          child: ClipOval(
                            child: Text(
                                service.userProfile.firstName
                                        ?.substring(0, 1) ??
                                    "",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? pickedFile = await imagePicker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  var croppedFile =
                                      await ImageCropper().cropImage(
                                          sourcePath: pickedFile.path,
                                          cropStyle: CropStyle.circle,
                                          androidUiSettings: AndroidUiSettings(
                                            toolbarTitle:
                                                AppLocalizations.of(context)
                                                    .cropper,
                                            toolbarColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            toolbarWidgetColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          iosUiSettings: IOSUiSettings(
                                            minimumAspectRatio: 1.0,
                                            title: AppLocalizations.of(context)
                                                .cropper,
                                            doneButtonTitle:
                                                AppLocalizations.of(context)
                                                    .doneButton,
                                            cancelButtonTitle:
                                                AppLocalizations.of(context)
                                                    .cancelButton,
                                          ));

                                  var path =
                                      "images/" + service.userProfile!.id!;
                                  if (croppedFile != null) {
                                    EasyLoading.show(
                                        maskType: EasyLoadingMaskType.black);
                                    TaskSnapshot snapshot = await storage
                                        .ref()
                                        .child(path)
                                        .putFile(croppedFile);
                                    if (snapshot.state == TaskState.error) {
                                      ToastController.showError(
                                          AppLocalizations.of(context)
                                              .avatarUpdateUnsuccess,
                                          context);
                                    } else if (snapshot.state ==
                                        TaskState.success) {
                                      final String downloadUrl =
                                          await snapshot.ref.getDownloadURL();
                                      service.userProfile?.photoUrl =
                                          downloadUrl;
                                      service.updateProfile(
                                          userProfileDataset:
                                              service.userProfile!,
                                          success: (result) {
                                            StorageController
                                                .database?.userProfileDao
                                                .updateUserProfile(
                                                    service.userProfile);
                                            setState(() {
                                              EasyLoading.dismiss();
                                            });
                                          },
                                          failure: (error) {
                                            EasyLoading.dismiss();
                                            ToastController.showError(
                                                AppLocalizations.of(context)
                                                    .avatarUpdateUnsuccess,
                                                context);
                                          });
                                    }
                                  }
                                }
                              },
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    Icons.image,
                                    size: 14,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ) // change this children
                                  ),
                            ))
                      ]),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
