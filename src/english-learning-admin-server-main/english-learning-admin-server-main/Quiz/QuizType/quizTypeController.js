const quizTypeService = require('./quizTypeService');

const getAllQuizTypes = async () => {
  return await quizTypeService.getAllQuizTypes();
};

const getQuizType = async ({ id }) => {
  return await quizTypeService.getQuizTypeById(id);
};

const addQuizType = async (data) => {
  return await quizTypeService.addQuizType(data);
};

const updateQuizType = async (id, newData) => {
  return await quizTypeService.updateQuizType(id, newData);
};

const deleteAllQuizTypes = async () => {
  return await quizTypeService.deleteAllQuizTypes();
};

const deleteQuizTypeById = async ({ id }) => {
  return await quizTypeService.deleteQuizTypeById(id);
};

module.exports = {
  getAllQuizTypes,
  getQuizType,
  addQuizType,
  updateQuizType,
  deleteAllQuizTypes,
  deleteQuizTypeById
};
