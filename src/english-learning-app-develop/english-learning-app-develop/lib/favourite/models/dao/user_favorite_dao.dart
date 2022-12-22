import 'package:floor/floor.dart';
import 'package:learning_english_app/favourite/models/dataset/user_favourite_dataset.dart';

@dao
abstract class UserFavouriteDao {
  @Query('SELECT * FROM USER_FAVOURITE WHERE id = :id')
  Future<UserFavouriteDataset?> findUserFavouriteById(String id);

  @Query('SELECT * FROM USER_FAVOURITE WHERE userId = :userId')
  Future<List<UserFavouriteDataset>> getUserFavouriteByUserId(String userId);

  @Query(
      'SELECT * FROM USER_FAVOURITE WHERE userId = :userId and wordId = :wordId')
  Future<UserFavouriteDataset?> getUserFavouriteByUserIdAndWordId(
      String userId, String wordId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUserFavouriteDataset(
      List<UserFavouriteDataset> userFavourites);

  @Query('DELETE FROM USER_FAVOURITE')
  Future<int?> deleteFromUserFavourite();

  @Query(
      'DELETE FROM USER_FAVOURITE WHERE userId = :userId and wordId = :wordId')
  Future<void> deleteBaseOnUserIdAndWord(String userId, String wordId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOneRecord(UserFavouriteDataset userFavouriteDataset);

  @transaction
  Future<void> insertListUserFavouriteTransaction(
      List<UserFavouriteDataset> userFavouriteList) async {
    await insertUserFavouriteDataset(userFavouriteList);
  }
}
