const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const feedbackController = require('./feedbackController');
const { VERSION, ROUTES } = require('../routes/constant');
const wrap = require('../shares/handleError');

const { verifyUser } = require('../authenticate/authenticate')

// authenticate
router.all('*', verifyUser);

// get all
// router.get(`/${VERSION}${ROUTES.FEEDBACK.GET_ALL}`, wrap(async (req, res) => {
//   const result = await feedbackController.getAllFeedback();
//   res.send(result);
// }));

// search feedback
router.get(`/${VERSION}${ROUTES.FEEDBACK.GET_BY_FIELD_ID}`, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await feedbackController.searchFeedback(queryObj);
  res.send(result);
}));

// get feedback by id
router.get(`/${VERSION}${ROUTES.FEEDBACK.GET_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await feedbackController.getFeedbackById(id);
  res.send(result);
}));

// Add feedback
router.post(`/${VERSION}${ROUTES.FEEDBACK.CREATE_ONE}`, wrap(async (req, res) => {
  const userId = req.user._id;
  const result = await feedbackController.addFeedback(userId, req.body);
  res.send(result);
}));

// Update feedback
router.post(`/${VERSION}${ROUTES.FEEDBACK.UPDATE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;
  const result = await feedbackController.updateFeedback(id, updateData);
  res.send(result);
}));

// Delete all feedback
router.get(`/${VERSION}${ROUTES.FEEDBACK.DELETE_ALL}`, wrap(async (req, res) => {
  const result = await feedbackController.deleteAllFeedback();
  res.send(result);
}));

// Delete feedback by id
router.get(`/${VERSION}${ROUTES.FEEDBACK.DELETE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await feedbackController.deleteFeedbackById(id);
  res.send(result);
}));

module.exports = router;
