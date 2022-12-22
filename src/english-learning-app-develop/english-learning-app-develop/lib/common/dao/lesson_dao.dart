import 'package:floor/floor.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/leareng_log.dart';

@dao
abstract class LessonDao {
  @Query('SELECT * FROM LESSON WHERE id = :lessonId')
  Future<LessonDataset?> findLessonByLessonId(String lessonId);

  @Query('SELECT * FROM LESSON')
  Future<List<LessonDataset>> getAllCategory();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateLesson(LessonDataset word);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertLesson(List<LessonDataset> categories);

  @Query('DELETE FROM LESSON')
  Future<int?> deleteAllCategory();

  @Query('SELECT * FROM LESSON WHERE subCategory = :subCategory')
  Future<List<LessonDataset?>> findLessonBysubCategory(String subCategory);

  Future<LessonDataset?> findLessonAndResultBySubCategory(
    String id,
  ) async {
    var sql = """ 
      SELECT L.*,LS.point,LS.completedAt,LS.totalIncorrect,LS.accuracy,LS.completionTime,LU.isCompleted,LU.isBlock FROM LESSON L
		INNER JOIN LESSON_USER_SCORE LS ON L.id = LS.lessonId 
    INNER JOIN LESSON_USER LU ON LU.lessonId = L.id
	WHERE  L.id  = :id
      AND LS.userId = :userId
		  AND DATETIME(LS.completedAt) = (SELECT MAX(DATETIME(completedAt)) FROM LESSON_USER_SCORE where lessonId = LS.lessonId)
      LIMIT 1
    """;
    var userId = StorageController.getCurrentUserId();
    var result = await StorageController.database!.database.rawQuery(sql, [id,userId]);
    if (result.isEmpty) {
      return null;
    } else {
      var element = result[0];
      LearnEngLog.logger.i(element);
      LessonDataset lessonDataset = LessonDataset();
      lessonDataset.accuracy = element["accuracy"] as double;
      lessonDataset.completedAt = element["completedAt"] as String;
      lessonDataset.completionTime = element["completionTime"] as String;
      lessonDataset.totalIncorrect = element["totalIncorrect"] as int;
      lessonDataset.point = element["point"] as int;
      lessonDataset.isBlock = element["isBlock"] as int;
      lessonDataset.isCompleted = element["isCompleted"] as int;
      return lessonDataset;
    }
  }

  @transaction
  Future<void> insertListCategoryTransaction(
      List<LessonDataset> lessonList) async {
    await insertLesson(lessonList);
  }
}
