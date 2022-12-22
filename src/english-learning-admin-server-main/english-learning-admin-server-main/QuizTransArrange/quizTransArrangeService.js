const mongoose = require('mongoose');
const QuizTransArrange = require('./quizTransArrangeModel');
const QuizTypeService = require('../Quiz/QuizType/quizTypeService');
const assert = require('assert');
const QuizService = require('../Quiz/quizService');

// create
const addQuiz = async (data) => {
  const { lessonId, wordId, originSentence, viPhrase, viSentence } = data;
  assert.notEqual(lessonId, undefined);
  assert.notEqual(wordId, undefined);
  assert.notEqual(originSentence, undefined);
  assert.notEqual(viPhrase, undefined);
  assert.notEqual(viSentence, undefined);

  // add new record for quiz details in quizTransArranges table
  const newQuizTransArrange = new QuizTransArrange(data);
  const quizTransArrangeResult = await newQuizTransArrange.save();

  // add record to Quiz table
  const { type, _id } = quizTransArrangeResult;
  const res = await QuizTypeService.getQuizType({ name: type });
  const quizResult = await QuizService.addQuiz({
    quiz_type: res[0]._id,
    quiz_id: _id
  });

  return [quizTransArrangeResult, quizResult];
};

// read
const getAllQuizzes = async () => {
  const filter = {
    isDeleted: false
  };
  return await QuizTransArrange.find(filter);
};

const getQuizById = async (quizId) => {
  const options = {
    _id: mongoose.Types.ObjectId(quizId),
    isDeleted: false
  };

  return await QuizTransArrange.find(options);
};

// search quiz
const searchQuiz = async (queryObj) => {
  return await QuizTransArrange.find(queryObj);
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

  return await QuizTransArrange.findOneAndUpdate(filter, update, options);
};

// delete
const deleteAllQuizzes = async () => {
  return await QuizTransArrange.deleteMany();
};

const deleteQuizById = async (quizId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(quizId)
  // };
  //
  // return await QuizTransArrange.deleteMany(options);
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
