import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_pronouce_dataset.dart';

@dao
abstract class QuizRightPronouceDao {
  @Query('SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE id = :quizId')
  Future<QuizRightPronouceDataset?> findQuizByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizRightPronouceDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizRightPronouceDataset> quizList);

  @Query('DELETE FROM QUIZ_RIGHT_PRONOUCE')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE lessonId = :lessonId')
  Future<List<QuizRightPronouceDataset?>> findQuizByLessonId(String lessonId);

  @Query('SELECT * FROM QUIZ_RIGHT_PRONOUCE WHERE wordId =:wordId')
  Future<List<QuizRightPronouceDataset>> findQuizByWordId(String wordId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<QuizRightPronouceDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
