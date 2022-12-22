const quizRightProService = require('./quizRightProService');

const getAllQuizzes = async () => {
  return await quizRightProService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizRightProService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizRightProService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizRightProService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizRightProService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizRightProService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizRightProService.deleteQuizById(id);
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
