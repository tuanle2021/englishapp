const lessonService = require('./lessonService');

const getAllLesson = async () => {
  return await lessonService.getAllLessons();
};

const getLessonById = async (lessonId) => {
  return await lessonService.getLessonById(lessonId);
};

const searchLesson = async (queryObj) => {
  return await lessonService.searchLesson(queryObj);
};

const addLesson = async (data) => {
  return await lessonService.addLesson(data);
};

const updateLesson = async (lessonId, data) => {
  return await lessonService.updateLesson(lessonId, data);
};

const deleteAllLesson = async () => {
  return await lessonService.deleteAllLessons();
};

const deleteLessonById = async (lessonId) => {
  return await lessonService.deleteLessonById(lessonId);
};

module.exports = {
  getAllLesson,
  getLessonById,
  searchLesson,
  addLesson,
  updateLesson,
  deleteAllLesson,
  deleteLessonById
};
