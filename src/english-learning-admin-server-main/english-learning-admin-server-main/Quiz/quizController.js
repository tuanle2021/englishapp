const quizService = require('./quizService');

const getAllQuizzes = async () => {
  return await quizService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizService.deleteQuizById(id);
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
