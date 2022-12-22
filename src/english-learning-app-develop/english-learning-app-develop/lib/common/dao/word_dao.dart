import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';

@dao
abstract class WordDao {
  @Query('SELECT * FROM WORD WHERE id = :wordId')
  Future<WordDataset?> findWordById(String wordId);

  @Query('SELECT * FROM WORD WHERE id IN (:listId)')
  Future<List<WordDataset?>?> getListWordById(List<String> listId);

  @Query("""SELECT * FROM WORD WHERE word LIKE  :search || '%' """)
  Future<List<WordDataset>> searchWordByText(String search);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateWord(WordDataset word);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertWord(List<WordDataset> words);

  @Query('DELETE FROM WORD')
  Future<int?> deleteAllWord();

  @Query("""SELECT * FROM WORD where id IN (
SELECT distinct wordId from (
		SELECT wordId FROM QUIZ_FILL_CHAR where lessonId = :lessonId
		UNION ALL
		SELECT wordId FROM QUIZ_FILL_WORD where lessonId = :lessonId
		UNION ALL
		SELECT wordId FROM QUIZ_RIGHT_WORD WHERE lessonId = :lessonId
		UNION ALL
		SELECT wordId FROM QUIZ_RIGHT_PRONOUCE WHERE lessonId = :lessonId
		UNION ALL
		SELECT wordId FROM QUIZ_TRANS_ARRANGE WHERE lessonId = :lessonId
  ))""")
  Future<List<WordDataset>> getWordByLessonId(String lessonId);

  @transaction
  Future<void> insertListWordTransaction(List<WordDataset> words) async {
    await insertWord(words);
  }
}
