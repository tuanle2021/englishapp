const express = require('express');
const router = express.Router();
const assert = require('assert');
const isNil = require('lodash/fp/isNull');

const quizRightWordController = require('./quizRightWordController');
const { ROUTES } = require('../routes/constant');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('Quiz RightPro Arrange');
});

// get all quizzes
router.get(ROUTES.QUIZ_RIGHT_WORD.GET_ALL, wrap(async (req, res) => {
  const data = await quizRightWordController.getAllQuizzes();
  res.send(data);
}));

// search quiz
router.get(ROUTES.QUIZ_RIGHT_WORD.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }

  queryObj.isDeleted = false;

  const data = await quizRightWordController.searchQuiz(queryObj);
  res.send(data);
}));

// create a quiz
router.post(ROUTES.QUIZ_RIGHT_WORD.CREATE_ONE, wrap(async (req, res) => {
  const result = await quizRightWordController.addQuiz(req.body);
  res.send(result);
}));

// delete all quizzes
router.get(ROUTES.QUIZ_RIGHT_WORD.DELETE_ALL, wrap(async (req, res) => {
  const result = await quizRightWordController.deleteAllQuizzes();
  res.send(result);
}));

// update quiz
router.post(ROUTES.QUIZ_RIGHT_WORD.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);

  const result = await quizRightWordController.updateQuiz(id, req.body);
  res.send(result);
}));

// delete a quiz by id
router.get(ROUTES.QUIZ_RIGHT_WORD.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await quizRightWordController.deleteQuizById({ id });
  res.send(result);
}));

// get quiz by id
router.get(ROUTES.QUIZ_RIGHT_WORD.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);
  const data = await quizRightWordController.getQuiz({ id });
  res.send(data);
}));

module.exports = router;
