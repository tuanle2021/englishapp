const feedbackService = require('./feedbackService');

const getAllFeedback = async () => {
  return await feedbackService.getAllFeedbacks();
};

const getFeedbackById = async (feedbackId) => {
  return await feedbackService.getFeedbackById(feedbackId);
};

const searchFeedback = async (queryObj) => {
  return await feedbackService.searchFeedback(queryObj);
};

const addFeedback = async (userId, data) => {
  return await feedbackService.addFeedback(userId, data);
};

const updateFeedback = async (feedbackId, data) => {
  return await feedbackService.updateFeedback(feedbackId, data);
};

const deleteAllFeedback = async () => {
  return await feedbackService.deleteAllFeedbacks();
};

const deleteFeedbackById = async (feedbackId) => {
  return await feedbackService.deleteFeedbackById(feedbackId);
};

module.exports = {
  getAllFeedback,
  getFeedbackById,
  searchFeedback,
  addFeedback,
  updateFeedback,
  deleteAllFeedback,
  deleteFeedbackById
};
