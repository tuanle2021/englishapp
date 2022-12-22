const quizFillWordService = require('./quizFillWordService');

const getAllQuizzes = async () => {
  return await quizFillWordService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizFillWordService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizFillWordService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizFillWordService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizFillWordService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizFillWordService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizFillWordService.deleteQuizById(id);
};

module.exports = {
  getAllQuizzes,
  getQuiz,
  searchQuiz,
  addQuiz,
  updateQuiz,
  deleteAllQuizzes,
  deleteQuizById
};
