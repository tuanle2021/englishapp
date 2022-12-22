import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/lesson/lesson_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user_score/lesson_user_score_dataset.dart';

@dao
abstract class LessonUserScoreDao {
  @Query('SELECT * FROM LESSON_USER_SCORE WHERE id = :lessonId')
  Future<LessonUserScoreDataset?> findRecord(String lessonId);

  @Query('SELECT * FROM LESSON_USER_SCORE')
  Future<List<LessonUserScoreDataset>> getAllRecord();

  @Query('SELECT * FROM LESSON_USER_SCORE WHERE lessonId = :lessonId')
  Future<List<LessonUserScoreDataset>> getRecordByLessonId(String lessonId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateRecord(LessonUserScoreDataset lessonScore);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOneRecord(LessonUserScoreDataset lessonScore);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecord(List<LessonUserScoreDataset> lessonScoreList);

  @Query('DELETE FROM LESSON_USER_SCORE')
  Future<int?> deleteAllCategory();

  
  @Query(""" SELECT LUS.* FROM LESSON_USER_SCORE LUS INNER JOIN LESSON L ON L.id = LUS.lessonId 
  INNER JOIN SUBCATEGORY SUB ON SUB.id = L.subCategory 
  INNER JOIN CATEGORIES CAT ON CAT.id = SUB.category 
  WHERE CAT.id = :categoryId
  AND LUS.userId = :userId
  """)
  Future<List<LessonUserScoreDataset>?> findLessonUserScoreBaseOnCatIdAndUserId(String categoryId,String userId);

  @transaction
  Future<void> insertLessonUserScoreTransaction(
      List<LessonUserScoreDataset> lessonList) async {
    await insertRecord(lessonList);
  }
}
