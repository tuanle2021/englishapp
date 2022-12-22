const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const lessonController = require('./lessonController');
const { ROUTES } = require('../routes/constant');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// get all
router.get(ROUTES.LESSON.GET_ALL, wrap(async (req, res) => {
  const result = await lessonController.getAllLesson();
  res.send(result);
}));

// search lesson
router.get(ROUTES.LESSON.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await lessonController.searchLesson(queryObj);
  res.send(result);
}));

// get lesson by id
router.get(ROUTES.LESSON.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await lessonController.getLessonById(id);
  res.send(result);
}));

// Add lesson
router.post(ROUTES.LESSON.CREATE_ONE, wrap(async (req, res) => {
  const result = await lessonController.addLesson(req.body);
  res.send(result);
}));

// Update lesson
router.post(ROUTES.LESSON.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;

  const result = await lessonController.updateLesson(id, updateData);
  res.send(result);
}));

// Delete all lesson
router.get(ROUTES.LESSON.DELETE_ALL, wrap(async (req, res) => {
  const result = await lessonController.deleteAllLesson();
  res.send(result);
}));

// Delete lesson by id
router.get(ROUTES.LESSON.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await lessonController.deleteLessonById(id);
  res.send(result);
}));

module.exports = router;
