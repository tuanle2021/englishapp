const quizRightWordService = require('./quizRightWordService');

const getAllQuizzes = async () => {
  return await quizRightWordService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizRightWordService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizRightWordService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizRightWordService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizRightWordService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizRightWordService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizRightWordService.deleteQuizById(id);
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
