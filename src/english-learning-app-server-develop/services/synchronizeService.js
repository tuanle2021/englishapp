const Category = require("../Category/categoryModel");
const CategoryUser = require("../CategoryUser/categoryUserModel");
const Lesson = require("../Lesson/lessonModel");
const LessonUser = require("../LessonUser/lessonUserModel");
const LessonUserScore = require("../LessonUserScore/lessonUserScoreModel");
const { compareCate, compareLess } = require("../shares/arrayUtils");
const createUserData = async (user) => {
  const categories = await Category.find({});
  categories.sort(compareCate);
  const lessons = await Lesson.find({});
  lessons.sort(compareLess);
  const userId = user._id;

  const category_user = [];
  for (let i = 0; i < categories.length; i++) {
    const categoryId = categories[i]._id;
    const newCategoryUser = new CategoryUser({
      userId: userId,
      categoryId: categoryId,
    });
    await newCategoryUser.save();
    category_user.push(newCategoryUser);
  }
  const lesson_user = [];
  for (let i = 0; i < lessons.length; i++) {
    const lessonId = lessons[i]._id;
    const newLessonUser = new LessonUser({
      userId: userId,
      lessonId: lessonId,
    });
    await newLessonUser.save();
    lesson_user.push(newLessonUser);
  }

  return {
    userProfile: user,
    category_user: category_user,
    lesson_user: lesson_user,
  };
};

const updateUserData = async (userId) => {
  const categories = await Category.find({});
  categories.sort(compareCate);
  const lessons = await Lesson.find({});
  lessons.sort(compareLess);
  const category_user = [];
  for (let i = 0; i < categories.length; i++) {
    const categoryId = categories[i]._id;
    const findResult = await CategoryUser.find({userId: userId, categoryId: categoryId})
    if (findResult.length > 0) {
      category_user.push(findResult[0])
      continue;
    }
    const newCategoryUser = new CategoryUser({
      userId: userId,
      categoryId: categoryId,
    });
    await newCategoryUser.save();
    category_user.push(newCategoryUser);
  }
  const lesson_user = [];
  for (let i = 0; i < lessons.length; i++) {
    
    const lessonId = lessons[i]._id;
    const findResult = await LessonUser.find({lessonId: lessonId, userId: userId})
    if (findResult.length >0) {
      lesson_user.push(findResult[0])
      continue;
    }
    const newLessonUser = new LessonUser({
      userId: userId,
      lessonId: lessonId,
    });
    await newLessonUser.save();
    lesson_user.push(newLessonUser);
  }

  return {
    category_user: category_user,
    lesson_user: lesson_user,
  };
};


module.exports = {
  createUserData: createUserData,
  updateUserData: updateUserData
};
