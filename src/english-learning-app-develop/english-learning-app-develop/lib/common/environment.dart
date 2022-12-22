import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learning_english_app/common/constants.dart';

class Environment {
  static String get fileName =>
      kReleaseMode ? ".env.production" : ".env.development";
  static String get apiUrl => Platform.isAndroid
      ? dotenv.env['API_URL_ANDROID'] ?? "http://10.0.2.2:3000"
      : dotenv.env['API_URL_IOS'] ?? "";
  static bool get isDebug => kReleaseMode ? false : true;

  static List<String> updateDataBase = [
    TableName.WORD,
    TableName.CATEGORIES,
    TableName.LESSON,
    TableName.SUB_CATEGORY,
    TableName.QUIZZ_FILL_CHAR,
    TableName.QUIZZ_FILL_WORD,
    TableName.QUIZZ_RIGHT_PRONOUNCE,
    TableName.QUIZZ_RIGHT_WORD,
    TableName.QUIZZ_TRANS_ARRANGE
  ];
}
