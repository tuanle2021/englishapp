const quizTransArrangeService = require('./quizTransArrangeService');

const getAllQuizzes = async () => {
  return await quizTransArrangeService.getAllQuizzes();
};

const getQuiz = async ({ id }) => {
  return await quizTransArrangeService.getQuizById(id);
};

const searchQuiz = async (queryObj) => {
  return await quizTransArrangeService.searchQuiz(queryObj);
};

const addQuiz = async (data) => {
  return await quizTransArrangeService.addQuiz(data);
};

const updateQuiz = async (quizId, newData) => {
  return await quizTransArrangeService.updateQuiz(quizId, newData);
};

const deleteAllQuizzes = async () => {
  return await quizTransArrangeService.deleteAllQuizzes();
};

const deleteQuizById = async ({ id }) => {
  return await quizTransArrangeService.deleteQuizById(id);
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
