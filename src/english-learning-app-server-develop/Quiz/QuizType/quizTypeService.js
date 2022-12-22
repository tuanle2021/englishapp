const mongoose = require('mongoose');
const QuizType = require('./quizTypeModel');

// create
const addQuizType = async (data) => {
  const newQuizType = new QuizType(data);

  return await newQuizType.save();
};

// read
const getAllQuizTypes = async () => {
  const options = {
    isDeleted: false
  }
  return await QuizType.find(options);
};

const getQuizTypeById = async (quizTypeId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizTypeId)
  };

  return await QuizType.find(options);
};

const getQuizType = async (options) => {
  return await QuizType.find(options);
};

// update
const updateQuizType = async (id, newData) => {
  const filter = {
    _id: mongoose.Types.ObjectId(id),
    isDeleted: false
  };
  const update = {
    '$set': newData
  };
  const options = {
    new: true, // return updated doc
    upsert: false, // not create new doc
    runValidators: true // validate before update
  };

  return await QuizType.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizTypes = async () => {
  return await QuizType.deleteMany();
};

const deleteQuizTypeById = async (id) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(id)
  // };
  //
  // return await QuizType.deleteMany(options);
  return await updateQuizType(id, {
    isDeleted: true
  });
};

module.exports = {
  addQuizType,
  getAllQuizTypes,
  getQuizType,
  getQuizTypeById,
  updateQuizType,
  deleteAllQuizTypes,
  deleteQuizTypeById
};
