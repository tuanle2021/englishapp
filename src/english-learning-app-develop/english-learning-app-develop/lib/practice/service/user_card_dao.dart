import 'package:floor/floor.dart';
import 'package:learning_english_app/practice/service/user_card_dataset.dart';

@dao
abstract class UserCardDao {
  @Query('SELECT * FROM USER_CARD WHERE userId = :userId')
  Future<UserCardDataset?> findUserCardByUserId(String userId);

  
  @Query('SELECT * FROM USER_CARD')
  Future<List<UserCardDataset>> getAllLessonUser();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateUserCard(UserCardDataset userCardDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUserCard(List<UserCardDataset> userCards);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOneUserCard(UserCardDataset userCard);

  @Query('DELETE FROM USER_CARD')
  Future<int?> deleteAll();

  

  @transaction
  Future<void> insertListLessonTransaction(
      List<UserCardDataset> userCards) async {
    await insertUserCard(userCards);
  }
}
