import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_right_word_dataset.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_trans_arrange_dataset.dart';

@dao
abstract class QuizTransArrageDao {
  @Query('SELECT * FROM QUIZ_TRANS_ARRANGE WHERE id = :quizId')
  Future<QuizTransArrangeDataset?> findQuizByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizTransArrangeDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizTransArrangeDataset> quizList);

  @Query('DELETE FROM QUIZ_TRANS_ARRANGE')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ_TRANS_ARRANGE WHERE lessonId = :lessonId')
  Future<List<QuizTransArrangeDataset?>> findQuizByLessonId(String lessonId);

  @Query('SELECT * FROM QUIZ_TRANS_ARRANGE WHERE wordId =:wordId')
  Future<List<QuizTransArrangeDataset>> findQuizByWordId(String wordId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<QuizTransArrangeDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
