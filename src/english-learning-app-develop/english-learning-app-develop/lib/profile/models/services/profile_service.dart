import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_english_app/common/dao/category_user_dao.dart';
import 'package:learning_english_app/common/dao/lesson_user_dao.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/common/nagivation_service.dart';
import 'package:learning_english_app/common/controller/social_login_controller.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dao/word_dao.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/login/models/dao/token_dao.dart';
import 'package:learning_english_app/profile/models/dao/setting_dao.dart';
import 'package:learning_english_app/profile/models/dao/userprofile_dao.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:learning_english_app/profile/models/dataset/setting_dataset.dart';

class ProfileService {
  TokenDao? _tokenDao;
  UserProfileDao? _userProfileDao;
  LessonUserDao? _lessonUserDao;
  CategoryUserDao? _categoryUserDao;

  HttpClientService _httpClientService = new HttpClientService();
  UserProfileDataset userProfile = UserProfileDataset(id: "0");
  WordDao? _wordDao;
  SettingDataset? userSetting = null;

  void getUserProfile(
      VoidCallback? success(Object result), VoidCallback? failure(error)) {
    _tokenDao = StorageController.database!.tokenDao;
    var url = Environment.apiUrl + '/user/${AppInfo.apiVersion}/profile';
    _httpClientService.requestTo(
        url: url,
        method: HttpMethod.GET,
        parameters: null,
        success: success,
        failure: failure);
  }

  Future<SettingDataset?> getUserSetting() async {
    SettingDao settingDao = StorageController.database!.settingDao;
    if (settingDao != null) {
      try {
        var userId = DeviceInfo.deviceID;
        userSetting = await settingDao.findSetting(userId);
        LearnEngLog.logger.i("SELECT table SETTING " + userSetting.toString());
        return userSetting!;
      } catch (e) {
        LearnEngLog.logger.e(e.toString());
      }
    }
    return null;
  }

  void linkingAccount(
      {required String linkAccount,
      required String accessToken,
      required void Function()? success(Object result),
      required void Function()? failure(Object error)}) {
    if (linkAccount == "Google") {
      var userId = userProfile.id;
      var url = Environment.apiUrl + '/auth/${AppInfo.apiVersion}/link-google';
      Map<String, dynamic> parameter = Map<String, dynamic>();
      parameter["id"] = userProfile.id;
      parameter["access_token"] = accessToken;
      parameter["isHasOtherUser"] = false;
      _httpClientService.requestTo(
          url: url,
          method: HttpMethod.POST,
          success: success,
          parameters: parameter,
          failure: failure);
    } else if (linkAccount == "Facebook") {
      var userId = userProfile.id;
      var url =
          Environment.apiUrl + '/auth/${AppInfo.apiVersion}/link-facebook';
      Map<String, dynamic> parameter = Map<String, dynamic>();
      parameter["id"] = userProfile.id;
      parameter["access_token"] = accessToken;
      parameter["isHasOtherUser"] = false;
      _httpClientService.requestTo(
          url: url,
          method: HttpMethod.POST,
          success: success,
          parameters: parameter,
          failure: failure);
    }
    throw Exception("Parameter must be Google or Facebook");
  }

  void updateSetting() async {
    LearnEngLog.logger.i("Update table SETTING: " + userSetting!.toString());
    try {
      await StorageController.database!.settingDao.updateSetting(userSetting!);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  void updateProfile(
      {required UserProfileDataset userProfileDataset,
      required void Function()? success(Object result),
      required void Function()? failure(Object error)}) async {
    LearnEngLog.logger.i(userProfileDataset.toJson());
    var url = Environment.apiUrl + '/user/${AppInfo.apiVersion}/updateProfile';
    _httpClientService.requestTo(
        url: url,
        method: HttpMethod.POST,
        parameters: userProfileDataset.toJson(),
        success: success,
        failure: failure);
  }

  void signOut() async {
    _tokenDao = StorageController.database!.tokenDao;
    _userProfileDao = StorageController.database!.userProfileDao;
    _wordDao = StorageController.database!.wordDao;
    _categoryUserDao = StorageController.database!.categoryUserDao;
    _lessonUserDao = StorageController.database!.lessonUserDao;
    try {
      await _tokenDao!.deleteRToken("REFRESH_TOKEN");
      await _tokenDao!.deleteRToken("ACCESS_TOKEN");
      await _userProfileDao!
          .deleteUserProfile(StorageController.getCurrentUserId()!);
      StorageController.setCurrentUserId("");
      await _categoryUserDao!.deleteAll();
      await _lessonUserDao!.deleteAll();
      if (userProfile.authStrategy == "Google") {
        await SocialLoginController.googleSignIn.disconnect();
      } else if (userProfile.authStrategy == "Facebook") {
        await SocialLoginController.facebookAuth.logOut();
      }
      NavigationService.navigatorKey.currentState!
          .pushNamedAndRemoveUntil('/introduce', (route) => false);
      return;
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }
}
