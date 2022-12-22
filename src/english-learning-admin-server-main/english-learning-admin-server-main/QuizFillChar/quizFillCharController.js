const quizFillCharService = require('./quizFillCharService');

const getAllQuizzes = async () => {
  return await quizFillCharService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizFillCharService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizFillCharService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizFillCharService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizFillCharService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizFillCharService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizFillCharService.deleteQuizById(id);
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
