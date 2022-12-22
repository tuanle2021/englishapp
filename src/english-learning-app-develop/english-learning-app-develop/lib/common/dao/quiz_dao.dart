import 'package:floor/floor.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/quiz/quiz_dataset.dart';

@dao
abstract class QuizDao {
  @Query('SELECT * FROM QUIZ WHERE quiz_id = :quizId')
  Future<QuizDataset?> findQuizByQuizId(String quizId);

  @Query('SELECT * FROM QUIZ')
  Future<List<QuizDataset>> getAllQuiz();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateQuiz(QuizDataset quizDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuiz(List<QuizDataset> subCategoryList);

  @Query('DELETE FROM QUIZ')
  Future<int?> deleteAllQuiz();

  @Query('SELECT * FROM QUIZ WHERE quiz_type = :quizType')
  Future<List<QuizDataset?>> findQuizByQuizType(String quizType);

  Future<int> countNumberQuiz(String lessonId) async {
    var sql = """
         SELECT (
		(SELECT count(*) FROM QUIZ_FILL_CHAR where lessonId = :lessonId)
		+
		(SELECT count(*) FROM QUIZ_FILL_WORD where lessonId = :lessonId)
		+
		(SELECT count(*) FROM QUIZ_RIGHT_WORD WHERE lessonId = :lessonId)
		+
		(SELECT count(*) FROM QUIZ_RIGHT_PRONOUCE WHERE lessonId = :lessonId)
		+
		(SELECT count(*) FROM QUIZ_TRANS_ARRANGE WHERE lessonId = :lessonId)
    ) as num
  """;
    var result =
        await StorageController.database!.database.rawQuery(sql, [lessonId]);
    var resultInt = result[0] as Map<String, dynamic>;
    return resultInt["num"] as int;
  }

  @transaction
  Future<void> insertListQuizTransaction(List<QuizDataset> quizList) async {
    await insertQuiz(quizList);
  }
}
