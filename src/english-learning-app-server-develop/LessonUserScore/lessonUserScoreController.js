const lessonUserScoreService = require('./lessonUserScoreService');

const getAllLessonUserScore = async () => {
  return await lessonUserScoreService.getAllLessonUserScores();
};

const getLessonUserScoreById = async (lessonUserScoreId) => {
  return await lessonUserScoreService.getLessonUserScoreById(lessonUserScoreId);
};

const searchLessonUserScore = async (queryObj) => {
  return await lessonUserScoreService.searchLessonUserScore(queryObj);
};

const addLessonUserScore = async (data) => {
  return await lessonUserScoreService.addLessonUserScore(data);
};

const updateLessonUserScore = async (lessonUserScoreId, data) => {
  return await lessonUserScoreService.updateLessonUserScore(lessonUserScoreId, data);
};

const deleteAllLessonUserScore = async () => {
  return await lessonUserScoreService.deleteAllLessonUserScores();
};

const deleteLessonUserScoreById = async (lessonUserScoreId) => {
  return await lessonUserScoreService.deleteLessonUserScoreById(lessonUserScoreId);
};

module.exports = {
  getAllLessonUserScore,
  getLessonUserScoreById,
  searchLessonUserScore,
  addLessonUserScore,
  updateLessonUserScore,
  deleteAllLessonUserScore,
  deleteLessonUserScoreById
};
