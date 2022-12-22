import 'package:floor/floor.dart';
import 'package:learning_english_app/profile/models/dataset/userprofile_dataset.dart';


@dao
abstract class UserProfileDao {
  @Query('SELECT * FROM USER WHERE id = :id')
  Future<UserProfileDataset?> findUserProfile(String id);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateUserProfile(UserProfileDataset userProfileDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertUserProfile(UserProfileDataset userProfileDataset);

  @Query('DELETE FROM USER where id = :userId')
  Future<void> deleteUserProfile(String userId);
}
