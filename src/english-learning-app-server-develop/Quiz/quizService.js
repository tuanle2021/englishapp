const mongoose = require('mongoose');
const Quiz = require('./quizModel');
const QuizFillChar = require('../QuizFillChar/quizFillCharModel');
const QuizFillWord = require('../QuizFillWord/quizFillWordModel');
const QuizRightPronounce = require('../QuizRightPro/quizRightProModel');
const QuizRightWord = require('../QuizRightWord/quizRightWordModel');
const QuizTransArrange = require('../QuizTransArrange/quizTransArrangeModel');

// create
const addQuiz = async (data) => {
  const newQuiz = new Quiz(data);

  return await newQuiz.save();
};

// read
const getAllQuizzes = async () => {
  // return await Quiz.find();
  const filter = {
    isDeleted: false
  };

  return await Promise.all([
    QuizFillChar.find(filter),
    QuizFillWord.find(filter),
    QuizRightPronounce.find(filter),
    QuizRightWord.find(filter),
    QuizTransArrange.find(filter)
  ]);
};

const getQuizById = async (quizId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };

  return await Quiz.find(options);
};

// search quiz
const searchQuiz = async (queryObj) => {
  return await Quiz.find(queryObj);
};

// update
const updateQuiz = async (quizId, newData) => {
  const filter = {
    _id: mongoose.Types.ObjectId(quizId),
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

  return await Quiz.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizzes = async () => {
  return await Quiz.deleteMany();
};

const deleteQuizById = async (quizId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(quizId)
  // };
  //
  // return await Quiz.deleteMany(options);
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
