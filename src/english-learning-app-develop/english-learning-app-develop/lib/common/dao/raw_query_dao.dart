import 'package:learning_english_app/common/controller/storage_controller.dart';
import 'package:learning_english_app/common/dataset/category/category_dataset.dart';

import '../constants.dart';

class RawQueryDao {
  final database = StorageController.database!.database;

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

    List<Map> result = await database.rawQuery(sql, [userId]);
    result.forEach((element) {
      CategoryDataset categoryDataset = CategoryDataset();
      categoryDataset.id = element["id"] as String;
      categoryDataset.name = element["name"] as String;
      categoryDataset.created_at = element["created_at"] as String;
      categoryDataset.levelType = element["levelType"] as String;
      categoryDataset.isDeleted = (element["isDeleted"] as int) == 0 ? false : true;
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
