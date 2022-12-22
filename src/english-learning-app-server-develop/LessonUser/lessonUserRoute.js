const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const lessonUserController = require('./lessonUserController');
const { VERSION, ROUTES } = require('../routes/constant');
const wrap = require('../shares/handleError');

const { verifyUser } = require('../authenticate/authenticate')

// authenticate
router.all('*', verifyUser);

// get all
// router.get(`/${VERSION}${ROUTES.LESSON_USER.GET_ALL}`, wrap(async (req, res) => {
//   const result = await lessonUserController.getAllLessonUser();
//   res.send(result);
// }));

// search lesson
router.get(`/${VERSION}${ROUTES.LESSON_USER.GET_BY_FIELD_ID}`, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await lessonUserController.searchLessonUser(queryObj);
  res.send(result);
}));

// get lesson by id
router.get(`/${VERSION}${ROUTES.LESSON_USER.GET_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await lessonUserController.getLessonUserById(id);
  res.send(result);
}));

// Add lesson
router.post(`/${VERSION}${ROUTES.LESSON_USER.CREATE_ONE}`, wrap(async (req, res) => {
  const result = await lessonUserController.addLessonUser(req.body);
  res.send(result);
}));

// Update lesson
router.post(`/${VERSION}${ROUTES.LESSON_USER.UPDATE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;
  const result = await lessonUserController.updateLessonUser(id, updateData);
  res.send(result);
}));

// Delete all lesson
router.get(`/${VERSION}${ROUTES.LESSON_USER.DELETE_ALL}`, wrap(async (req, res) => {
  const result = await lessonUserController.deleteAllLessonUser();
  res.send(result);
}));

// Delete lesson by id
router.get(`/${VERSION}${ROUTES.LESSON_USER.DELETE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await lessonUserController.deleteLessonUserById(id);
  res.send(result);
}));

module.exports = router;
