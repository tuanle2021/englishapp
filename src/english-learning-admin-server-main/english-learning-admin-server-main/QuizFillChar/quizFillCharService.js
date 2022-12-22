const mongoose = require('mongoose');
const QuizFillChar = require('./quizFillCharModel');
const assert = require('assert');

const QuizTypeService = require('../Quiz/QuizType/quizTypeService');
const QuizService = require('../Quiz/quizService');

// create
const addQuiz = async (data) => {
  const { lessonId, wordId } = data;
  assert.notEqual(lessonId, undefined);
  assert.notEqual(wordId, undefined);

  // add new record for quiz details in quizzesFillChar table
  const newQuizFillChar = new QuizFillChar(data);
  const quizFillCharResult = await newQuizFillChar.save();

  // add record to Quiz table
  const { type, _id } = quizFillCharResult;
  const res = await QuizTypeService.getQuizType({ name: type });
  const quizResult = await QuizService.addQuiz({
    quiz_type: res[0]._id,
    quiz_id: _id
  });

  return [quizFillCharResult, quizResult];
};

// read
const getAllQuizzes = async () => {
  const filter = {
    isDeleted: false
  };
  return await QuizFillChar.find(filter);
};

const getQuizById = async (quizId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };

  return await QuizFillChar.find(options);
};

// search quiz
const searchQuiz = async (queryObj) => {
  return await QuizFillChar.find(queryObj);
};

// update
const updateQuiz = async (quizId, newData) => {
  const filter = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };
  const update = {
    $set: newData
  };
  const options = {
    new: true, // return updated doc
    upsert: false, // not create new doc
    runValidators: true // validate before update
  };

  return await QuizFillChar.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizzes = async () => {
  return await QuizFillChar.deleteMany();
};

const deleteQuizById = async (quizId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(quizId)
  // };
  //
  // return await QuizFillChar.deleteMany(options);
  return await updateQuiz(quizId, {
    isDeleted: true
  })
};

module.exports = {
  addQuiz,
  getAllQuizzes,
  getQuizById,
  searchQuiz,
  updateQuiz,
  deleteAllQuizzes,
  deleteQuizById
};
