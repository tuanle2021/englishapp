import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';
import 'package:learning_english_app/common/dataset/lesson_user/lesson_user_dataset.dart';

@dao
abstract class LessonUserDao {
  @Query('SELECT * FROM LESSON_USER WHERE userId = :userId')
  Future<LessonUserDataset?> findLessonUserByUserId(String userId);

  @Query('SELECT * FROM LESSON_USER WHERE userId = :userId AND lessonId = :lessonId')
  Future<LessonUserDataset?> findLessonUserByUserIdAndLessonId(String userId,String lessonId);

  @Query('SELECT * FROM LESSON_USER')
  Future<List<LessonUserDataset>> getAllLessonUser();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateLessonUser(LessonUserDataset lessonUserDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertLessonUser(List<LessonUserDataset> lessonUsers);

    @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOneLessonUser(LessonUserDataset lessonUsers);

  @Query('DELETE FROM LESSON_USER')
  Future<int?> deleteAll();

  @transaction
  Future<void> insertListLessonTransaction(
      List<LessonUserDataset> lessonUsers) async {
    await insertLessonUser(lessonUsers);
  }
}
