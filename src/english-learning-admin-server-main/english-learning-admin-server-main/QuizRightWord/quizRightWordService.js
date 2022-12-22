const mongoose = require('mongoose');
const assert = require('assert');

const QuizRightWord = require('./quizRightWordModel');
const QuizTypeService = require('../Quiz/QuizType/quizTypeService');
const QuizService = require('../Quiz/quizService');

// create
const addQuiz = async (data) => {
  const { lessonId, wordId } = data;
  assert.notEqual(lessonId, undefined);
  assert.notEqual(wordId, undefined);

  // add new record for quiz details in quizzesRightWord table
  const newQuizRightWord = new QuizRightWord(data);
  const quizRightWordResult = await newQuizRightWord.save();

  // add record to Quiz table
  const { type, _id } = quizRightWordResult;
  const res = await QuizTypeService.getQuizType({ name: type });
  const quizResult = await QuizService.addQuiz({
    quiz_type: res[0]._id,
    quiz_id: _id
  });

  return [quizRightWordResult, quizResult];
};

// read
const getAllQuizzes = async () => {
  const filter = {
    isDeleted: false
  };
  return await QuizRightWord.find(filter);
};

const getQuizById = async (quizId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };

  return await QuizRightWord.find(options);
};

// search quiz
const searchQuiz = async (queryObj) => {
  return await QuizRightWord.find(queryObj);
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

  return await QuizRightWord.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizzes = async () => {
  return await QuizRightWord.deleteMany();
};

const deleteQuizById = async (quizId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(quizId)
  // };
  //
  // return await QuizRightWord.deleteMany(options);
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
