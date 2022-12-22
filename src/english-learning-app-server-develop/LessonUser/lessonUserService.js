const mongoose = require('mongoose');
const LessonUser = require('./lessonUserModel');
const LessonUserScore = require('../LessonUserScore/lessonUserScoreModel')
const assert = require('assert');
const User = require('../User/userModel')
const Lesson = require('../Lesson/lessonModel')

const getAllLessonUsers = async () => {
  const filter = {
    isDeleted: false
  };

  return await LessonUser.find(filter);
};

// Get LessonUser by LessonUser id
const getLessonUserById = async (LessonUserId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(LessonUserId),
    isDeleted: false
  };
  return await LessonUser.findOne(filter);
};

// search LessonUser
const searchLessonUser = async (queryObj) => {
  return await LessonUser.find(queryObj);
};

// Add new LessonUser
const addLessonUser = async (data) => {
  const { userId, lessonId } = data;
  assert.notEqual(userId, undefined);
  assert.notEqual(lessonId, undefined);
  const user = await User.findOne(userId)
  const lesson = await Lesson.findOne(lesson)
  if (!user || !lesson) {
    return {
      error: "User hoac lesson khong ton tai"
    }
  }
  const newLessonUser = new LessonUser(data);
  return await newLessonUser.save();
};

// Update LessonUser
const updateLessonUser = async (LessonUserId, data) => {
  let lessonUserDataset = data.lessonUser
  console.log(lessonUserDataset)
  let lessonUserScoreDataset = new LessonUserScore(data.lessonUserScore)
  const saveScore = await lessonUserScoreDataset.save()
  const updateLessonUser = await LessonUser.findOneAndUpdate({_id: mongoose.Types.ObjectId(lessonUserDataset.id)},{isCompleted:true},{new:true})
  return {success:true,lessonUserScoreDataset: saveScore,updateLessonUser :updateLessonUser}
};

const deleteAllLessonUsers = async () => {
  return await LessonUser.deleteMany({});
};

// Delete LessonUser by id
const deleteLessonUserById = async (LessonUserId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(LessonUserId)
  // }
  // return await LessonUser.deleteOne(filter)

  return await updateLessonUser(LessonUserId, {
    isDeleted: true
  });
};

module.exports = {
  getAllLessonUsers,
  getLessonUserById,
  searchLessonUser,
  addLessonUser,
  updateLessonUser,
  deleteAllLessonUsers,
  deleteLessonUserById
};
