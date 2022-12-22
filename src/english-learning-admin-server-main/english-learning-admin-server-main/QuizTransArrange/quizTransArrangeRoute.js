const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');
const assert = require('assert');

const { ROUTES } = require('../routes/constant');
const quizTransArrangeController = require('./quizTransArrangeController');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('Quiz Translate Arrange');
});

// get all quizzes
router.get(ROUTES.QUIZ_TRANS_ARRANGE.GET_ALL, wrap(async (req, res) => {
  const data = await quizTransArrangeController.getAllQuizzes();
  res.send(data);
}));

// search quiz
router.get(ROUTES.QUIZ_TRANS_ARRANGE.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const data = await quizTransArrangeController.searchQuiz(queryObj);
  res.send(data);
}));

// create a quiz
router.post(ROUTES.QUIZ_TRANS_ARRANGE.CREATE_ONE, wrap(async (req, res) => {
  const result = await quizTransArrangeController.addQuiz(req.body);
  res.send(result);
}));

// delete all quizzes
router.get(ROUTES.QUIZ_TRANS_ARRANGE.DELETE_ALL, wrap(async (req, res) => {
  const result = await quizTransArrangeController.deleteAllQuizzes();
  res.send(result);
}));


// update quiz
router.post(ROUTES.QUIZ_TRANS_ARRANGE.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);

  const result = await quizTransArrangeController.updateQuiz(id, req.body);
  res.send(result);
}));

// delete a quiz by id
router.get(ROUTES.QUIZ_TRANS_ARRANGE.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await quizTransArrangeController.deleteQuizById({ id });
  res.send(result);
}));

// get quiz by id
router.get(ROUTES.QUIZ_TRANS_ARRANGE.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);

  const data = await quizTransArrangeController.getQuiz({ id });
  res.send(data);
}));

module.exports = router;
