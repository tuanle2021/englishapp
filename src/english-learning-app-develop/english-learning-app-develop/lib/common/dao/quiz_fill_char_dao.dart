import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_char_dataset.dart';

@dao
abstract class QuizFillCharDao {
  @Query('SELECT * FROM QUIZ_FILL_CHAR WHERE id = :quizId')
  Future<QuizFillCharDataset?> findQuizByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizFillCharDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizFillCharDataset> quizList);

  @Query('DELETE FROM QUIZ_FILL_CHAR')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ_FILL_CHAR WHERE lessonId = :lessonId')
  Future<List<QuizFillCharDataset?>> findQuizByLessonId(String lessonId);

  @Query('SELECT * FROM QUIZ_FILL_CHAR WHERE wordId =:wordId')
  Future<List<QuizFillCharDataset>> findQuizByWordId(String wordId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<QuizFillCharDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
