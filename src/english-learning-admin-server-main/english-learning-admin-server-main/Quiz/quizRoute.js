const express = require('express');
const router = express.Router();
const quizController = require('./quizController');
const { ROUTES } = require('../routes/constant');
const isNil = require('lodash/fp/isNull');
const quizTypeRouter = require('./QuizType/quizTypeRoute');

// nested routes by attaching them as middleware
router.use(ROUTES.QUIZ.TYPE.ROOT, quizTypeRouter);

// get all quizzes
router.get(ROUTES.QUIZ.GET_ALL,async (req, res) => {
  const data = await quizController.getAllQuizzes();
  res.send(data);
});

// search quiz
router.get(ROUTES.QUIZ.GET_BY_FIELD_ID, async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }

  const data = await quizController.searchQuiz(queryObj);
  res.send(data);
});

// create a quiz
// => AUTO ADD A QUIZ WHEN ADDING SEPCIFIC QUIZ (E.G: QUIZFILLCHAR, .etc)
// router.post(ROUTES.QUIZ.CREATE_ONE,async (req, res) => {
//   const newQuiz = req.body;
//   const result = await quizController.addQuiz(newQuiz);
//   res.send(result);
// });

// // delete all quizzes
// router.get(ROUTES.QUIZ.DELETE_ALL,async (req, res) => {
//   const result = await quizController.deleteAllQuizzes();
//   res.send(result);
// });

// // update quiz
// router.post(ROUTES.QUIZ.UPDATE_BY_ID,async (req, res) => {
//   const { id } = req.params;
//   const updateData = req.body;
//   const result = await quizController.updateQuiz(id, updateData);
//   res.send(result);
// });

// // delete a quiz by id
// router.get(ROUTES.QUIZ.DELETE_BY_ID,async (req, res) => {
//   const { id } = req.params;
//   const result = await quizController.deleteQuizById({ id });
//   res.send(result);
// });

// get quiz by id
router.get(ROUTES.QUIZ.GET_BY_ID,async (req, res) => {
  const { id } = req.params;
  const data = await quizController.getQuiz({ id });
  res.send(data);
});

module.exports = router;
