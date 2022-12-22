const mongoose = require('mongoose');
const assert = require('assert');

const QuizFillWord = require('./quizFillWordModel');
const QuizTypeService = require('../Quiz/QuizType/quizTypeService');
const QuizService = require('../Quiz/quizService');

// create
const addQuiz = async (data) => {
  const { lessonId, wordId, leftOfWord, rightOfWord, viSentence, correctChoice, firstChoice, secondChoice, thirdChoice  } = data;
  assert.notEqual(lessonId, undefined);
  assert.notEqual(wordId, undefined);
  assert.notEqual(leftOfWord, undefined);
  assert.notEqual(rightOfWord, undefined);
  assert.notEqual(viSentence, undefined);
  assert.notEqual(correctChoice, undefined);
  assert.notEqual(firstChoice, undefined);
  assert.notEqual(secondChoice, undefined);
  assert.notEqual(thirdChoice, undefined);

  // add new record for quiz details in quizzesFillWord table
  const newQuizFillWord = new QuizFillWord(data);
  const quizFillWordResult = await newQuizFillWord.save();

  // add record to Quiz table
  const { type, _id } = quizFillWordResult;
  const res = await QuizTypeService.getQuizType({ name: type });
  const quizResult = await QuizService.addQuiz({
    quiz_type: res[0]._id,
    quiz_id: _id
  });

  return [quizFillWordResult, quizResult];
};

// read
const getAllQuizzes = async () => {
  const filter = {
    isDeleted: false
  };
  return await QuizFillWord.find(filter);
};

const getQuizById = async (quizId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };

  return await QuizFillWord.find(options);
};

// search quiz
const searchQuiz = async (queryObj) => {
  return await QuizFillWord.find(queryObj);
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

  return await QuizFillWord.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizzes = async () => {
  return await QuizFillWord.deleteMany();
};

const deleteQuizById = async (quizId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(quizId)
  // };
  //
  // return await QuizFillWord.deleteMany(options);
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
