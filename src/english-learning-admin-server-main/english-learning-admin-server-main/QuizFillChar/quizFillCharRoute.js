const express = require('express');
const assert = require('assert');
const isNil = require('lodash/fp/isNull');
const router = express.Router();

const quizFillCharController = require('./quizFillCharController');
const { ROUTES } = require('../routes/constant');
const wrap = require('../shares/handleError');
const authService = require('../Auth/authService');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('Quiz FillChar');
});

// get all quizzes
router.get(ROUTES.QUIZ_FILL_CHAR.GET_ALL, wrap(async (req, res) => {
  const data = await quizFillCharController.getAllQuizzes();
  res.send(data);
}));

// search quiz
router.get(ROUTES.QUIZ_FILL_CHAR.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }

  queryObj.isDeleted = false;

  const data = await quizFillCharController.searchQuiz(queryObj);
  res.send(data);
}));

// create a quiz
router.post(ROUTES.QUIZ_FILL_CHAR.CREATE_ONE, wrap(async (req, res) => {
  const result = await quizFillCharController.addQuiz(req.body);
  res.send(result);
}));

// delete all quizzes
router.get(ROUTES.QUIZ_FILL_CHAR.DELETE_ALL, wrap(async (req, res) => {
  const result = await quizFillCharController.deleteAllQuizzes();
  res.send(result);
}));

// update quiz
router.post(ROUTES.QUIZ_FILL_CHAR.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);

  const result = await quizFillCharController.updateQuiz(id, req.body);
  res.send(result);
}));

// delete a quiz by id
router.get(ROUTES.QUIZ_FILL_CHAR.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await quizFillCharController.deleteQuizById({ id });
  res.send(result);
}));

// get quiz by id
router.get(ROUTES.QUIZ_FILL_CHAR.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  assert.notEqual(id, undefined);
  const data = await quizFillCharController.getQuiz({ id });
  res.send(data);
}));

module.exports = router;
