const mongoose = require('mongoose');
const Lesson = require('./lessonModel');
const assert = require('assert');
const SubCategory = require('../SubCategory/subCategoryModel');

// Get all lessons
const getAllLessons = async () => {
  const filter = {
    isDeleted: false
  };

  return await Lesson.find(filter);
};

// Get lesson by lesson id
const getLessonById = async (lessonId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(lessonId),
    isDeleted: false
  };
  return await Lesson.findOne(filter);
};

// search lesson
const searchLesson = async (queryObj) => {
  return await Lesson.find(queryObj);
};

// Add new lesson
const addLesson = async (data) => {
  const { name, subCategoryId } = data;
  assert.notEqual(name, undefined);
  assert.notEqual(subCategoryId, undefined);
  const subCategory = await SubCategory.findOne({_id: subCategoryId})
  if (!subCategory) {
    return {
      error: "SubCategory khong ton tai"
    }
  }

  const newLesson = new Lesson(data);
  return await newLesson.save();
};

// Update lesson
const updateLesson = async (lessonId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(lessonId),
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await Lesson.findOneAndUpdate(filter, data, options);
};

// Delete all lessons
const deleteAllLessons = async () => {
  return await Lesson.deleteMany({});
};

// Delete lesson by id
const deleteLessonById = async (lessonId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(lessonId)
  // }
  // return await Lesson.deleteOne(filter)

  return await updateLesson(lessonId, {
    isDeleted: true
  });
};

module.exports = {
  getAllLessons,
  getLessonById,
  searchLesson,
  addLesson,
  updateLesson,
  deleteAllLessons,
  deleteLessonById
};
