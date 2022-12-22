// database.dart

// required package imports
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dao/category_dao.dart';
import 'package:learning_english_app/common/dao/category_user_dao.dart';
import 'package:learning_english_app/common/dao/lesson_dao.dart';
import 'package:learning_english_app/common/dao/lesson_user_dao.dart';
import 'package:learning_english_app/common/dao/lesson_user_score_dao.dart';
import 'package:learning_english_app/common/dao/phrase_dao.dart';
import 'package:learning_english_app/common/dao/quiz_dao.dart';
import 'package:learning_english_app/common/dao/quiz_fill_char_dao.dart';
import 'package:learning_english_app/common/dao/quiz_fill_word_dao.dart';
import 'package:learning_english_app/common/dao/quiz_right_pronouce.dart';
import 'package:learning_english_app/common/dao/quiz_right_word_dao.dart';
import 'package:learning_english_app/common/dao/quiz_trans_arrange_dao.dart';
import 'package:learning_english_app/common/dao/sub_category_dao.dart';
import 'package:learning_english_app/common/dao/word_dao.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/phrase_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';
import 'package:learning_english_app/common/dataset/sub_category/subcategory_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/favourite/models/dao/user_favorite_dao.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';
import 'package:learning_english_app/login/models/dao/token_dao.dart';
import 'package:learning_english_app/login/models/dataset/token_dataset.dart';
import 'package:learning_english_app/practice/service/user_card_dao.dart';
import 'package:learning_english_app/practice/service/user_card_dataset.dart';
import 'package:learning_english_app/profile/models/dao/setting_dao.dart';
import 'package:learning_english_app/profile/models/dao/userprofile_dao.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../profile/models/dataset/setting_dataset.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  TokenDataset,
  SettingDataset,
  UserProfileDataset,
  WordDataset,
  CategoryDataset,
  LessonDataset,
  SubCategoryDataset,
  QuizDataset,
  QuizFillCharDataset,
  QuizFillWordDataset,
  QuizRightPronouceDataset,
  QuizRightWordDataset,
  QuizTransArrangeDataset,
  ViPhraseDataset,
  CategoryUserDataset,
  LessonUserDataset,
  LessonUserScoreDataset,
  UserFavouriteDataset,
  UserCardDataset
])
abstract class AppDatabase extends FloorDatabase {
  TokenDao get tokenDao;
  SettingDao get settingDao;
  UserProfileDao get userProfileDao;
  WordDao get wordDao;
  CategoryDao get categoryDao;
  LessonDao get lessonDao;
  SubCategoryDao get subCategoryDao;
  QuizDao get quizDao;
  QuizFillCharDao get quizFillCharDao;
  QuizFillWordDao get quizFillWordDao;
  QuizRightPronouceDao get quizRightPronouceDao;
  QuizRightWordDao get quizRightWordDao;
  QuizTransArrageDao get quizTransArrageDao;
  ViPhraseDao get viPhraseDao;
  CategoryUserDao get categoryUserDao;
  LessonUserDao get lessonUserDao;
  LessonUserScoreDao get lessonUserScoreDao;
  UserFavouriteDao get userFavouriteDao;
  UserCardDao get userCardDao;
}
