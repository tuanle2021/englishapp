import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dao/quiz_right_pronouce.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_for_extend.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/common/environment.dart';
import 'package:learning_english_app/common/http_client_service.dart';
import 'package:learning_english_app/common/leareng_log.dart';

class QuizService {
  static LessonDataset? lesson = null;

  static LessonUserDataset? lessonUserDataset = null;

  static int _totalPoint = 0;

  static int _selectedIndex = 0;

  static int _maxQuizIndex = 1;

  static int _totalCorrect = 0;

  static int _totalWrong = 0;

  static int retryTime = 0;

  static var quizDoDuration = Stopwatch();

  static HttpClientService _httpClientService = HttpClientService();

  static final _lessonUserDao = StorageController.database!.lessonUserDao;

  static void onCorrectQuiz({int plusPoint = 10, QuizExtend? quiz = null}) {
    _totalPoint += plusPoint;
    _totalCorrect++;
    if (quiz is QuizFillCharDataset) {
      //TODO: coding for fillCharDataset;
    } else if (quiz is QuizFillWordDataset) {
      //TODO: coding for fillWordDataset;
    } else if (quiz is QuizRightPronouceDao) {
      //TODO: coding for rightPronouceDataset;
    } else if (quiz is QuizRightWordDataset) {
      //TODO: coding for quizRightWordDataset;
    } else if (quiz is QuizTransArrangeDataset) {
      //TODO: coding for quizTransArrage
    }
  }

  static Stopwatch? timer;
  static void startClock() {
    timer = Stopwatch();
    timer?.reset();
    timer?.start();
  }

  static void stopClock() {
    timer?.stop();
  }

  static void onInCorrectQuiz({int minusPoint = 10, QuizExtend? quiz = null}) {
    _totalPoint -= minusPoint;
    _totalWrong++;
    if (quiz is QuizFillCharDataset) {
      //TODO: coding for fillCharDataset;
    } else if (quiz is QuizFillWordDataset) {
      //TODO: coding for fillWordDataset;
    } else if (quiz is QuizRightPronouceDao) {
      //TODO: coding for rightPronouceDataset;
    } else if (quiz is QuizRightWordDataset) {
      //TODO: coding for quizRightWordDataset;
    } else if (quiz is QuizTransArrangeDataset) {
      //TODO: coding for quizTransArrage
    }
  }

  static int getTotalCorrect() {
    return _totalCorrect;
  }

  static int getTotalIncorrect() {
    return _totalWrong;
  }

  static int getTotalPoint() {
    return _totalPoint;
  }

  static void setSelectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
  }

  static int getSelectedIndex() {
    return _selectedIndex;
  }

  static int getMaxSelectedIndex() {
    return _maxQuizIndex;
  }

  static void setMaxQuizIndex(int maxQuizIndex) {
    _maxQuizIndex = maxQuizIndex;
  }

  static void updateProgress(
      String userId,
      String lessonId,
      VoidCallback? success(Object result),
      VoidCallback? failure(Object error)) async {
    if (lesson != null) {
      LearnEngLog.logger.i(userId);
      LearnEngLog.logger.i(lessonId);
      stopClock();

      StorageController.database?.wordDao
          .getWordByLessonId(lessonId)
          .then((value) {
        for (var item in value) {
          Map<String, dynamic> data = Map();
          data["wordId"] = item.id;
          data["userId"] = StorageController.getCurrentUserId();
          data["catId"] = StorageController.getCurrentCategoryId();
          var url = Environment.apiUrl + '/usercard/';
          _httpClientService.requestTo(
              url: url,
              parameters: data,
              method: HttpMethod.POST,
              success: (result) {

              },
              failure: (error) {

              });
        }
      });

      _lessonUserDao
          .findLessonUserByUserIdAndLessonId(userId, lessonId)
          .then((result) async {
        var url = Environment.apiUrl +
            '/lesson-user/${AppInfo.apiVersion}/update/${result!.id}';
        LessonUserDataset? lessonUser;
        if (result != null) {
          lessonUser = result;
          lessonUser.isCompleted = true;
        }
        await _lessonUserDao.updateLessonUser(lessonUser!);
        double resultPercent = QuizService.getTotalIncorrect().toDouble() /
            QuizService.getMaxSelectedIndex().toDouble();
        LessonUserScoreDataset lessonUserScoreDataset = LessonUserScoreDataset(
            id: "",
            lessonId: lessonId,
            userId: userId,
            totalIncorrect: _totalWrong,
            point: _totalPoint,
            accuracy: 1 - resultPercent,
            completionTime: timer?.elapsedMilliseconds.toString(),
            completedAt: DateTime.now().millisecondsSinceEpoch.toString());
        var parameter = Map<String, dynamic>();
        timer?.reset();
        parameter["lessonUser"] = lessonUser;
        parameter["lessonUserScore"] = lessonUserScoreDataset;
        _httpClientService.requestTo(
            url: url,
            parameters: parameter,
            method: HttpMethod.POST,
            success: success,
            failure: failure);
      });
    }
  }

  static void resetQuizSection() {
    _totalPoint = 0;

    _selectedIndex = 0;

    _maxQuizIndex = 1;

    _totalCorrect = 0;

    _totalWrong = 0;
  }
}
