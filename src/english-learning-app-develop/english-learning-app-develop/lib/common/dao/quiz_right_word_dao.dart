import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';

@dao
abstract class QuizRightWordDao {
  @Query('SELECT * FROM QUIZ_RIGHT_WORD WHERE id = :quizId')
  Future<QuizRightWordDataset?> findQuizByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizRightWordDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizRightWordDataset> quizList);

  @Query('DELETE FROM QUIZ_RIGHT_WORD')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ_RIGHT_WORD WHERE lessonId = :lessonId')
  Future<List<QuizRightWordDataset?>> findQuizByLessonId(String lessonId);

  @Query('SELECT * FROM QUIZ_RIGHT_WORD WHERE wordId =:wordId')
  Future<List<QuizRightWordDataset>> findQuizByWordId(String wordId);

  @Query('SELECT * FROM QUIZ_RIGHT_WORD WHERE wordId =:wordId and name LIKE "%FLASHCARD%"')
  Future<List<QuizRightWordDataset>> findQuizByWordIdForPracticePage(String wordId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<QuizRightWordDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
