const express = require('express');
const router = express.Router();
const assert = require('assert');
const isNil = require('lodash/fp/isNull');

const { ROUTES } = require('../routes/constant');
const quizRightProController = require('./quizRightProController');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('Quiz Right Pronounce controller');
});

// get all quizzes
router.get(ROUTES.QUIZ_RIGHT_PRONOUNCE.GET_ALL, wrap(async (req, res) => {
  const data = await quizRightProController.getAllQuizzes();
  res.send(data);
}));

// search quiz
router.get(ROUTES.QUIZ_RIGHT_PRONOUNCE.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }

  queryObj.isDeleted = false;

  const data = await quizRightProController.searchQuiz(queryObj);
  res.send(data);
}));

// create a quiz
router.post(ROUTES.QUIZ_RIGHT_PRONOUNCE.CREATE_ONE, wrap(async (req, res) => {
  const result = await quizRightProController.addQuiz(req.body);
  res.send(result);
}));

// delete all quizzes
router.get(ROUTES.QUIZ_RIGHT_PRONOUNCE.DELETE_ALL, wrap(async (req, res) => {
  const result = await quizRightProController.deleteAllQuizzes();
  res.send(result);
}));

// update quiz
router.post(ROUTES.QUIZ_RIGHT_PRONOUNCE.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);

  const result = await quizRightProController.updateQuiz(id, req.body);
  res.send(result);
}));

// delete a quiz by id
router.get(ROUTES.QUIZ_RIGHT_PRONOUNCE.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await quizRightProController.deleteQuizById({ id });
  res.send(result);
}));

// get quiz by id
router.get(ROUTES.QUIZ_RIGHT_PRONOUNCE.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);
  const data = await quizRightProController.getQuiz({ id });
  res.send(data);
}));

module.exports = router;
