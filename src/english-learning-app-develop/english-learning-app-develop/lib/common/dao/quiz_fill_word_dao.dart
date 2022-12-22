import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_fill_word_dataset.dart';

@dao
abstract class QuizFillWordDao {
  @Query('SELECT * FROM QUIZ_FILL_WORD WHERE id = :quizId')
  Future<QuizFillWordDataset?> findQuizByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizFillWordDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizFillWordDataset> quizList);

  @Query('DELETE FROM QUIZ_FILL_WORD')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ_FILL_WORD WHERE lessonId = :lessonId')
  Future<List<QuizFillWordDataset?>> findQuizByLessonId(String lessonId);

  @Query('SELECT * FROM QUIZ_FILL_WORD WHERE wordId =:wordId')
  Future<List<QuizFillWordDataset>> findQuizByWordId(String wordId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<QuizFillWordDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
