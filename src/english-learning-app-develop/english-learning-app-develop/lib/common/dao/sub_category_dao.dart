import 'package:floor/floor.dart';
import 'package:learning_english_app/common/dataset/sub_category/subcategory_dataset.dart';

@dao
abstract class SubCategoryDao {
  @Query('SELECT * FROM SUBCATEGORY WHERE id = :lessonId')
  Future<SubCategoryDataset?> findsubCategoryBysubCategoryId(String lessonId);

  @Query('SELECT * FROM SUBCATEGORY')
  Future<List<SubCategoryDataset>> getAllCategory();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updatesubCategory(SubCategoryDataset subCategoryDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertsubCategory(List<SubCategoryDataset> subCategoryList);

  @Query('DELETE FROM SUBCATEGORY')
  Future<int?> deleteAllCategory();

  @Query('SELECT * FROM SUBCATEGORY WHERE category = :categoryId')
  Future<List<SubCategoryDataset?>> findsubCategoryByCategoryId(
      String categoryId);

  @transaction
  Future<void> insertListCategoryTransaction(
      List<SubCategoryDataset> subCategoryList) async {
    await insertsubCategory(subCategoryList);
  }
}
