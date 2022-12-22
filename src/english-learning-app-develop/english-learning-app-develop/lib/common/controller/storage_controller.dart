import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/phrase_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/common/dataset/sub_category/subcategory_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/extensions.dart';
import 'package:learning_english_app/common/leareng_log.dart';
import 'package:learning_english_app/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  static final secureStorage = new FlutterSecureStorage();
  static late final SharedPreferences userDefaultService;

  static void setCurrentCategoryId(String categoryId) {
    userDefaultService.setString("CurrentCategoryId", categoryId);
  }

  static String? getCurrentCategoryId() {
    return userDefaultService.get("CurrentCategoryId") as String? ?? "";
  }

  static void setCurrentUserId(String id) {
    userDefaultService.setString("CurrentUserId", id);
  }

  static String? getVersionUpdateApp() {
    return userDefaultService.get("VersionUpdateApp") as String? ?? "0";
  }

  static void setVersionUpdateApp(String versionApp) {
    userDefaultService.setString("VersionUpdateApp",versionApp);
  }

  static String? getCurrentUserId() {
    return userDefaultService.get("CurrentUserId") as String? ?? "";
  }

  static void setCompleteInitFirstTime(bool value) {
    userDefaultService.setBool("CompleInit", value);
  }

  static bool? getCompleteInit() {
    return userDefaultService.getBool("CompleInit") ?? false;
  }

  static Future<String> _getWordJson() {
    return rootBundle.loadString('assets/app_data/words.json');
  }

  static Future<String> _getCategoryJson() {
    return rootBundle.loadString('assets/app_data/categories.json');
  }

  static Future<String> _getsubCategoryJson() {
    return rootBundle.loadString('assets/app_data/subCategories.json');
  }

  static Future<String> _getLessonJson() {
    return rootBundle.loadString('assets/app_data/lessons.json');
  }

  static Future<String> _getQuizzesFillChar() {
    return rootBundle.loadString('assets/app_data/quizzesFillChar.json');
  }

  static Future<String> _getQuizzesFillWord() {
    return rootBundle.loadString('assets/app_data/quizzesFillWord.json');
  }

  static Future<String> _getQuizzesRightPronouce() {
    return rootBundle.loadString('assets/app_data/quizzesRightPronounce.json');
  }

  static Future<String> _getQuizzesRightWord() {
    return rootBundle.loadString('assets/app_data/quizzesRightWord.json');
  }

  static Future<String> _getQuizzesTransArrange() {
    return rootBundle.loadString('assets/app_data/quizzesTransArrange.json');
  }

  static String _getVersionInitAppData() {
    return userDefaultService.getString("AppDataVersion") ?? "-1";
  }

  static void _setVersionInitAppData(String version) {
    userDefaultService.setString("AppDataVersion", version);
  }

  static Future<void> initAppDataFromJson() async {
    if (_isInitAppDataFirstTime()) {
      for (int i = 0; i < Environment.updateDataBase.length; i++) {
        var databaseName = Environment.updateDataBase[i];
        switch (databaseName) {
          case TableName.WORD:
            {
              await loadWordData();
              LearnEngLog.logger.i("Word Data Loaded");
              break;
            }
          case TableName.CATEGORIES:
            {
              await loadCategoriesData();
              LearnEngLog.logger.i("Category Data Loaded");
              break;
            }
          case TableName.LESSON:
            {
              await loadLessonData();
              LearnEngLog.logger.i("Lesson Data Loaded");
              break;
            }
          case TableName.SUB_CATEGORY:
            {
              await loadsubCategoryData();
              LearnEngLog.logger.i("Sub Category Data Loaded");
              break;
            }
          case TableName.QUIZZ_FILL_CHAR:
            {
              await loadQuizzesFillChar();
              LearnEngLog.logger.i("Quiz Fill Char Data Loaded");
              break;
            }
          case TableName.QUIZZ_FILL_WORD:
            {
              await loadQuizzesFillWord();
              LearnEngLog.logger.i("Quiz Fill Word Data Loaded");
              break;
            }
          case TableName.QUIZZ_RIGHT_PRONOUNCE:
            {
              await loadQuizzesRightPronouce();
              LearnEngLog.logger.i("Quiz Right Pronouce Data Loaded");
              break;
            }
          case TableName.QUIZZ_RIGHT_WORD:
            {
              await loadQuizzesRightWord();
              LearnEngLog.logger.i("Quiz Right Word Data Loaded");
              break;
            }
          case TableName.QUIZZ_TRANS_ARRANGE:
            {
              await loadQuizzesTransArrange();
              LearnEngLog.logger.i("Quiz Trans Arrange Data Loaded");
              break;
            }
        }
      }
      _setVersionInitAppData(AppInfo.appVersion);
    } else {
      LearnEngLog.logger.i("Data loading already");
    }
  }

  static String lastVersion = "";

  static bool _isInitAppDataFirstTime() {
    LearnEngLog.logger.i("Current Version ${AppInfo.appVersion}");
    LearnEngLog.logger.i("Db version ${_getVersionInitAppData()}");
    if (AppInfo.appVersion != _getVersionInitAppData()) {
      lastVersion = _getVersionInitAppData();
      LearnEngLog.logger.i("Last verion $lastVersion");
      return true;
    }
    return false;
  }

  static Future<void> loadWordData() async {
    try {
      String wordJsonData = await _getWordJson();
      var wordMap = jsonDecode(wordJsonData) as List<dynamic>;
      List<WordDataset> wordList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = wordMap.length;
        for (int i = 0; i < lengthList; i++) {
          var word = wordMap[i] as Map;
          word.parseId();
          wordList.add(WordDataset.fromJson(word as Map<String, dynamic>));
        }
        await database?.wordDao.insertListWordTransaction(wordList);
      }
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadsubCategoryData() async {
    try {
      String subCategoryJsonData = await _getsubCategoryJson();
      var subCategoryMap = jsonDecode(subCategoryJsonData) as List<dynamic>;
      List<SubCategoryDataset> subCategoryList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = subCategoryMap.length;
        for (int i = 0; i < lengthList; i++) {
          var subCategory = subCategoryMap[i] as Map<String, dynamic>;
          subCategory.parseId();
          subCategory.parseDate();
          subCategoryList.add(SubCategoryDataset.fromJson(subCategory));
        }
        await database?.subCategoryDao
            .insertListCategoryTransaction(subCategoryList);
      }
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadLessonData() async {
    try {
      String lessonJsonData = await _getLessonJson();
      var lessonMap = jsonDecode(lessonJsonData) as List<dynamic>;
      List<LessonDataset> lessonList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = lessonMap.length;
        for (int i = 0; i < lengthList; i++) {
          var lesson = lessonMap[i] as Map<String, dynamic>;
          lesson.parseId();
          lesson.parseDate();
          lessonList.add(LessonDataset.fromJson(lesson));
        }
        await database?.lessonDao.insertLesson(lessonList);
      }
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadCategoriesData() async {
    try {
      String categoryJsonData = await _getCategoryJson();
      var categoryMap = jsonDecode(categoryJsonData) as List<dynamic>;
      List<CategoryDataset> categoryList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = categoryMap.length;
        for (int i = 0; i < lengthList; i++) {
          var category = categoryMap[i] as Map<String, dynamic>;
          category.parseId();
          category.parseDate();
          categoryList.add(CategoryDataset.fromJson(category));
        }
        await database?.categoryDao.insertListCategoryTransaction(categoryList);
      }
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadQuizzesFillChar() async {
    try {
      String quizData = await _getQuizzesFillChar();
      var quizMap = jsonDecode(quizData) as List<dynamic>;
      List<QuizFillCharDataset> quizList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = quizMap.length;
        for (int i = 0; i < lengthList; i++) {
          var quiz = quizMap[i] as Map<String, dynamic>;
          quiz.parseDate();
          quiz.parseId();
          quizList.add(QuizFillCharDataset.fromJson(quiz));
        }
      }
      await database?.quizFillCharDao.insertListQuizTransaction(quizList);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadQuizzesFillWord() async {
    try {
      String quizData = await _getQuizzesFillWord();
      var quizMap = jsonDecode(quizData) as List<dynamic>;
      List<QuizFillWordDataset> quizList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = quizMap.length;
        for (int i = 0; i < lengthList; i++) {
          var quiz = quizMap[i] as Map<String, dynamic>;
          quiz.parseDate();
          quiz.parseId();
          quizList.add(QuizFillWordDataset.fromJson(quiz));
        }
      }
      await database?.quizFillWordDao.insertListQuizTransaction(quizList);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadQuizzesRightPronouce() async {
    try {
      String quizData = await _getQuizzesRightPronouce();
      var quizMap = jsonDecode(quizData) as List<dynamic>;
      List<QuizRightPronouceDataset> quizList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = quizMap.length;
        for (int i = 0; i < lengthList; i++) {
          var quiz = quizMap[i] as Map<String, dynamic>;
          quiz.parseDate();
          quiz.parseId();
          quizList.add(QuizRightPronouceDataset.fromJson(quiz));
        }
      }
      await database?.quizRightPronouceDao.insertListQuizTransaction(quizList);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadQuizzesRightWord() async {
    try {
      String quizData = await _getQuizzesRightWord();
      var quizMap = jsonDecode(quizData) as List<dynamic>;
      List<QuizRightWordDataset> quizList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = quizMap.length;
        for (int i = 0; i < lengthList; i++) {
          var quiz = quizMap[i] as Map<String, dynamic>;
          quiz.parseDate();
          quiz.parseId();
          quizList.add(QuizRightWordDataset.fromJson(quiz));
        }
      }
      await database?.quizRightWordDao.insertListQuizTransaction(quizList);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static Future<void> loadQuizzesTransArrange() async {
    try {
      String quizData = await _getQuizzesTransArrange();
      var quizMap = jsonDecode(quizData) as List<dynamic>;
      List<QuizTransArrangeDataset> quizList = [];
      if (database != null && getCompleteInit() == false) {
        var lengthList = quizMap.length;
        for (int i = 0; i < lengthList; i++) {
          var quiz = quizMap[i] as Map<String, dynamic>;
          quiz.parseDate();
          quiz.parseId();
          var quizDataset = QuizTransArrangeDataset.fromJson(quiz);
          quizList.add(quizDataset);
          var phraseList = quizDataset.viPhrase?.map<ViPhraseDataset>((e) {
            return ViPhraseDataset(quizId: quizDataset.id, viPhrase: e);
          }).toList();
          phraseList != null
              ? await database?.viPhraseDao.insertPhrase(phraseList)
              : 1;
        }
      }
      await database?.quizTransArrageDao.insertListQuizTransaction(quizList);
    } catch (e) {
      LearnEngLog.logger.e(e.toString());
    }
  }

  static AppDatabase? database;
  //neeed to call first
  static Future<void> buildDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
