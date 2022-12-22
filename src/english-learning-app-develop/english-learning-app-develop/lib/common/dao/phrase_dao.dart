import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/quiz/phrase_dataset.dart';

@dao
abstract class ViPhraseDao {
  @Query('SELECT * FROM VI_PHRASE WHERE quiz_id = :quizId')
  Future<List<ViPhraseDataset>?> findViPhraseByQuizId(String quizId);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updatePhrase(ViPhraseDataset phraseDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPhrase(List<ViPhraseDataset> phraseDataset);

  @Query('DELETE FROM VI_PHRASE WHERE quiz_id = :quizId')
  Future<void> deleteViPhraseByQuizId(String quizId);

  @transaction
  Future<void> insertListQuizTransaction(
      List<ViPhraseDataset> phraseList) async {
    await deleteViPhraseByQuizId(phraseList[0].quizId ?? "");
    await insertPhrase(phraseList);
  }
}
