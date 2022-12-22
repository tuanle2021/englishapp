import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:learning_english_app/common/constants.dart';
import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';
import 'package:learning_english_app/common/dataset/word/word_dataset.dart';
import 'package:learning_english_app/common/extensions.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM CATEGORIES WHERE id = :categoryId')
  Future<CategoryDataset?> findCategoryById(String categoryId);

  @Query('SELECT * FROM CATEGORIES')
  Future<List<CategoryDataset>> getAllCategory();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateCategory(CategoryDataset categoryDataset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(List<CategoryDataset> categories);

  @Query('DELETE FROM CATEGORIES')
  Future<int?> deleteAllCategory();

  @transaction
  Future<void> insertListCategoryTransaction(
      List<CategoryDataset> categories) async {
    await insertCategory(categories);
  }

  Future<CategoryDataset> getCategoryAndUserScoreBaseOnCategoryId(
      String userId, String categoryId) async {
    List<CategoryDataset> categoryList = [];
    var sql = """SELECT tc.*, ifnull(uc.userLesson,0) as userLesson
FROM (SELECT c.*, count(l.name) as totalLesson
	  FROM CATEGORIES as c
	  LEFT JOIN subCategory sc on c.id = sc.category AND sc.isDeleted = 0
	  LEFT JOIN LESSON l on  sc.id = l.subCategory AND l.isDeleted = 0
      WHERE c.isDeleted = 0
	  GROUP BY c.id, c.name) as tc
LEFT JOIN
	 (SELECT c.id, c.name, count(*) AS userLesson
	  FROM LESSON_USER lu, LESSON l, subCategory sc, CATEGORIES c
	  WHERE 
			l.id = lu.lessonId AND
			lu.isCompleted = 1 AND
			l.subCategory = sc.id AND
      lu.userId = ? AND
      c.id = ? AND 
			sc.category = c.id AND
			l.isDeleted = 0 AND --check item wasn't deleted
			sc.isDeleted = 0 AND
			c.isDeleted = 0
	  GROUP BY c.id, c.name) AS uc ON tc.id = uc.id
  ORDER BY tc.created_at
  """;

    List<Map> result = await StorageController.database!.database
        .rawQuery(sql, [userId, categoryId]);
    result.forEach((element) {
      CategoryDataset categoryDataset = CategoryDataset();
      categoryDataset.id = element["id"] as String;
      categoryDataset.name = element["name"] as String;
      categoryDataset.image = element["image"] as String;
      categoryDataset.iconImage = Image.memory(ExtensionMethod.dataFromBase64String(categoryDataset.image ?? ""),width: categoryDataset.originalRadius,height: categoryDataset.originalRadius,);
      categoryDataset.created_at = element["created_at"] as String;
      categoryDataset.levelType = element["levelType"] as String;
      categoryDataset.isDeleted =
          (element["isDeleted"] as int) == 0 ? false : true;
      categoryDataset.updated_at = element["updated_at"] as String;
      categoryDataset.total = element["totalLesson"] as int;
      categoryDataset.completed = element["userLesson"] as int;
      categoryDataset.isOpenDialog = false;
      switch (categoryDataset.levelType) {
        case LevelType.BEGINNER:
          {
            categoryDataset.levelTypeValue = 1;
            break;
          }
        case LevelType.INTERMEDIATE:
          {
            categoryDataset.levelTypeValue = 2;
            break;
          }
        case LevelType.ADVANCED:
          {
            categoryDataset.levelTypeValue = 3;
            break;
          }
        case LevelType.PROFESSIONAL:
          {
            categoryDataset.levelTypeValue = 4;
            break;
          }
      }
      categoryList.add(categoryDataset);
    });
    return categoryList[0];
  }

  Future<List<CategoryDataset>> getCategoryAndUserScore(String userId) async {
    List<CategoryDataset> categoryList = [];
    var sql = """SELECT tc.*, ifnull(uc.userLesson,0) as userLesson
FROM (SELECT c.*, count(l.name) as totalLesson
	  FROM CATEGORIES as c
	  LEFT JOIN subCategory sc on c.id = sc.category AND sc.isDeleted = 0
	  LEFT JOIN LESSON l on  sc.id = l.subCategory AND l.isDeleted = 0
      WHERE c.isDeleted = 0
	  GROUP BY c.id, c.name) as tc
LEFT JOIN
	 (SELECT c.id, c.name, count(*) AS userLesson
	  FROM LESSON_USER lu, LESSON l, subCategory sc, CATEGORIES c
	  WHERE 
			l.id = lu.lessonId AND
			lu.isCompleted = 1 AND
			l.subCategory = sc.id AND
      lu.userId = ? AND
			sc.category = c.id AND
			l.isDeleted = 0 AND --check item wasn't deleted
			sc.isDeleted = 0 AND
			c.isDeleted = 0
	  GROUP BY c.id, c.name) AS uc ON tc.id = uc.id
  ORDER BY tc.created_at
  """;

    List<Map> result =
        await StorageController.database!.database.rawQuery(sql, [userId]);
    result.forEach((element) {
      CategoryDataset categoryDataset = CategoryDataset();
      categoryDataset.id = element["id"] as String;
      categoryDataset.name = element["name"] as String;
      categoryDataset.image = element["image"] as String;
      categoryDataset.iconImage = Image.memory(ExtensionMethod.dataFromBase64String(categoryDataset.image ?? ""),width: categoryDataset.originalRadius,height: categoryDataset.originalRadius,);
      categoryDataset.created_at = element["created_at"] as String;
      categoryDataset.levelType = element["levelType"] as String;
      categoryDataset.isDeleted =
          (element["isDeleted"] as int) == 0 ? false : true;
      categoryDataset.updated_at = element["updated_at"] as String;
      categoryDataset.total = element["totalLesson"] as int;
      categoryDataset.completed = element["userLesson"] as int;
      categoryDataset.isOpenDialog = false;
      switch (categoryDataset.levelType) {
        case LevelType.BEGINNER:
          {
            categoryDataset.levelTypeValue = 1;
            break;
          }
        case LevelType.INTERMEDIATE:
          {
            categoryDataset.levelTypeValue = 2;
            break;
          }
        case LevelType.ADVANCED:
          {
            categoryDataset.levelTypeValue = 3;
            break;
          }
        case LevelType.PROFESSIONAL:
          {
            categoryDataset.levelTypeValue = 4;
            break;
          }
      }
      categoryList.add(categoryDataset);
    });
    return categoryList;
  }
}
