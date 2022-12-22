const mongoose = require('mongoose');
const Feedback = require('./feedbackModel');
const assert = require('assert');
const User = require('../User/userModel')

const getAllFeedbacks = async () => {
  const filter = {
    isDeleted: false
  };

  return await Feedback.find(filter);
};

// Get Feedback by Feedback id
const getFeedbackById = async (feedbackId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(feedbackId),
    isDeleted: false
  };
  return await Feedback.findOne(filter);
};

// search Feedback
const searchFeedback = async (queryObj) => {
  return await Feedback.find(queryObj);
};

// Add new Feedback
const addFeedback = async (userId, data) => {
  data.userId = userId;
  assert.notEqual(userId, undefined);
  const user = await User.findOne(userId)
  if (!user) {
    return {
      error: "User khong ton tai"
    }
  }

  const newFeedback = new Feedback(data);
  return await newFeedback.save();
};

// Update Feedback
const updateFeedback = async (feedbackId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(feedbackId),
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await Feedback.findOneAndUpdate(filter, data, options);
};

const deleteAllFeedbacks = async () => {
  return await Feedback.deleteMany({});
};

// Delete Feedback by id
const deleteFeedbackById = async (feedbackId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(feedbackId)
  // }
  // return await Feedback.deleteOne(filter)

  return await updateFeedback(feedbackId, {
    isDeleted: true
  });
};

module.exports = {
  getAllFeedbacks,
  getFeedbackById,
  searchFeedback,
  addFeedback,
  updateFeedback,
  deleteAllFeedbacks,
  deleteFeedbackById
};
