const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizFillWord = new Schema({
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson',  },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.FILL_WORD },
  wordId: {type: Schema.Types.ObjectId, ref: 'Word',  },
  leftOfWord: { type: String, required: true },
  rightOfWord: { type: String, required: true },
  viSentence: { type: String, required: true },
  correctChoice: { type: String, required: true },
  firstChoice: { type: String, required: true },
  secondChoice: { type: String, required: true },
  thirdChoice: { type: String, required: true },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizFillWord.plugin(populatePlugin);
quizFillWord.plugin(timestampPlugin);

module.exports = mongoose.model('QuizFillWord', quizFillWord, 'quizzesFillWord');
