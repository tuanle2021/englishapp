import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/category_user/category_user_dataset.dart';

@dao
abstract class CategoryUserDao {
  @Query('SELECT * FROM CATEGORY_USER WHERE userId = :userId')
  Future<CategoryUserDataset?> findCategoryUserByUserId(String userId);

  @Query('SELECT * FROM CATEGORY_USER WHERE userId = :userId AND categoryId = :categoryId')
  Future<CategoryUserDataset?> findCategoryUserByUserIdAndCategoryId(String userId,String categoryId);

  @Query('SELECT * FROM CATEGORY_USER')
  Future<List<CategoryUserDataset>> getAllCategory();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateCategoryUser(CategoryUserDataset categoryUserDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategoryUser(List<CategoryUserDataset> categoryUsers);

  @Query('DELETE FROM CATEGORY_USER')
  Future<int?> deleteAll();

  @transaction
  Future<void> insertListCategoryTransaction(
      List<CategoryUserDataset> categories) async {
    await insertCategoryUser(categories);
  }
}
