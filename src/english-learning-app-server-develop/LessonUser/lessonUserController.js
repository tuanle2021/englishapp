const lessonUserService = require('./lessonUserService');

const getAllLessonUser = async () => {
  return await lessonUserService.getAllLessonUsers();
};

const getLessonUserById = async (lessonUserId) => {
  return await lessonUserService.getLessonUserById(lessonUserId);
};

const searchLessonUser = async (queryObj) => {
  return await lessonUserService.searchLessonUser(queryObj);
};

const addLessonUser = async (data) => {
  return await lessonUserService.addLessonUser(data);
};

const updateLessonUser = async (lessonUserId, data) => {
  return await lessonUserService.updateLessonUser(lessonUserId, data);
};

const deleteAllLessonUser = async () => {
  return await lessonUserService.deleteAllLessonUsers();
};

const deleteLessonUserById = async (lessonUserId) => {
  return await lessonUserService.deleteLessonUserById(lessonUserId);
};

module.exports = {
  getAllLessonUser,
  getLessonUserById,
  searchLessonUser,
  addLessonUser,
  updateLessonUser,
  deleteAllLessonUser,
  deleteLessonUserById
};
