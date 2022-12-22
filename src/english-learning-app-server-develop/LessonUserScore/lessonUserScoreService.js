const mongoose = require("mongoose");
const LessonUserScore = require("./lessonUserScoreModel");
const assert = require("assert");

const countUserPoint = async (userId) => {
  const lessonUserScores = await LessonUserScore.find({
    userId: mongoose.Types.ObjectId(userId),
  });
  let point = 0;
  for (let i = 0; i < lessonUserScores.length; i++) {
    point += lessonUserScores[i].point;
  }
  return point;
};

const getAllLessonUserScores = async () => {
  const filter = {
    isDeleted: false,
  };

  return await LessonUserScore.find(filter);
};

// Get LessonUserScore by LessonUserScore id
const getLessonUserScoreById = async (LessonUserScoreId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(LessonUserScoreId),
    isDeleted: false,
  };
  return await LessonUserScore.findOne(filter);
};

// search LessonUserScore
const searchLessonUserScore = async (queryObj) => {
  return await LessonUserScore.find(queryObj);
};

// Add new LessonUserScore
const addLessonUserScore = async (data) => {
  const { userId, lessonId } = data;
  assert.notEqual(userId, undefined);
  assert.notEqual(categoryId, undefined);
  const user = await User.findOne(userId);
  const category = await Category.findOne(categoryId);
  if (!user || !category) {
    return {
      error: "User hoac Cate khong ton tai",
    };
  }
  const newLessonUserScore = new LessonUserScore(data);
  return await newLessonUserScore.save();
};

// Update LessonUserScore
const updateLessonUserScore = async (LessonUserScoreId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(LessonUserScoreId),
    isDeleted: false,
  };
  const options = {
    new: true,
    upsert: false,
  };
  return await LessonUserScore.findOneAndUpdate(filter, data, options);
};

const deleteAllLessonUserScores = async () => {
  return await LessonUserScore.deleteMany({});
};

// Delete LessonUserScore by id
const deleteLessonUserScoreById = async (LessonUserScoreId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(LessonUserScoreId)
  // }
  // return await LessonUserScore.deleteOne(filter)

  return await updateLessonUserScore(LessonUserScoreId, {
    isDeleted: true,
  });
};

module.exports = {
  countUserPoint,
  getAllLessonUserScores,
  getLessonUserScoreById,
  searchLessonUserScore,
  addLessonUserScore,
  updateLessonUserScore,
  deleteAllLessonUserScores,
  deleteLessonUserScoreById,
};
