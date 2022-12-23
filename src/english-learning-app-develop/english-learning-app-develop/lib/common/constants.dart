import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:package_info_plus/package_info_plus.dart';

var pixelRatio = window.devicePixelRatio;
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;
var logicalHeight = logicalScreenSize.height;
var scaleRatio = logicalHeight * 0.0011;

class PaddingConstants {
  static final double extraSmall = 5 * scaleRatio;

  static final double small = 10 * scaleRatio;

  static final double med = 15 * scaleRatio;

  static final double large = 20 * scaleRatio;

  static final double extraLarge = 25 * scaleRatio;
}

class TableName {
  static const String WORD = "WORD";
  static const String CATEGORIES = "CATEGORIES";
  static const String USER = "USER";
  static const String SUB_CATEGORY = "SUB_CATEGORY";
  static const String LESSON = "LESSON";
  static const String QUIZZ_FILL_CHAR = "QUIZ_FILL_CHAR";
  static const String QUIZZ_FILL_WORD = "QUIZ_FILL_WORD";
  static const String QUIZZ_RIGHT_PRONOUNCE = "QUIZ_RIGHT_PRONOUCE";
  static const String QUIZZ_RIGHT_WORD = "QUIZ_RIGHT_WORD";
  static const String QUIZZ_TRANS_ARRANGE = "QUIZZ_TRANS_ARRANGE";
}

class LevelType {
  static const String BEGINNER = "BEGINNER";
  static const String INTERMEDIATE = "INTERMEDIATE";
  static const String ADVANCED = "ADVANCED";
  static const String PROFESSIONAL = "PROFESSIONAL";
}

class AppInfo {
  static String appVersion = "0";
  static String versionCheckUpdate = "0";
  static String apiVersion = "v1";
  static Future<void> getAppVersion() async {
    if (Environment.isDebug) {
      appVersion = "4";
    } else {
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        appVersion = packageInfo.version;
      } catch (e) {
        LearnEngLog.logger.e(e.toString());
      }
    }
  }
}

class API_URL {
  // const ROUTES = {
  // ROOT: '/',
  // WORD: {
  //   ROOT: '/word',
  //   GET_ALL_WORD: '/getAllWord'
  // },
  // AUTH: {
  //   ROOT: '/auth',
  //   REFRESH_TOKEN: '/refreshToken',
  //   SIGNUP: '/signup',
  //   GOOGLE_TOKEN: '/google-token',
  //   FACEBOOK_TOKEN: '/facebook-token',
  //   VERIFY_ACTIVATION_CODE: '/verifyActivationCode',
  //   SEND_ACTIVATION_CODE: '/sendActivationCode',
  //   LOGIN: '/login'
  // },
  // USER: {
  //   ROOT: '/user',
  //   PROFILE: '/profile',
  //   CHECK_EMAIL: '/check-email',
  //   UPDATE_PROFILE: '/updateProfile',
  //   FORGOT_PASSWORD: '/forgot-password',
  //   RESET_PASSWORD: '/reset-password',
  //   GEN_RESET_LINK: '/gen-reset-link',
  //   UPDATE_PASSWORD: '/update-password'
  // },
  // USER_CARD: {
  //   ROOT: '/usercard',
  //   GETALL: '/abc'
  // },
  // LESSON_USER: {
  //   ROOT: '/lesson-user',
  //   GET_ALL: '/all',
  //   GET_BY_FIELD_ID: '/search',
  //   GET_BY_ID: '/:id',
  //   CREATE_ONE: '/',
  //   UPDATE_BY_ID: '/update/:id',
  //   UPDATE_ALL: '/update/all',
  //   DELETE_ALL: '/delete/all',
  //   DELETE_BY_ID: '/delete/:id'
  // },
  // CATEGORY_USER: {
  //   ROOT: '/category-user',
  //   GET_ALL: '/all',
  //   GET_BY_FIELD_ID: '/search',
  //   GET_BY_ID: '/:id',
  //   CREATE_ONE: '/',
  //   UPDATE_BY_ID: '/update/:id',
  //   UPDATE_ALL: '/update/all',
  //   DELETE_ALL: '/delete/all',
  //   DELETE_BY_ID: '/delete/:id'
  // },
}

class DeviceInfo {
  static String deviceID = "";
  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor!;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.androidId!;
      return androidDeviceInfo.androidId;
    }
  }
}
