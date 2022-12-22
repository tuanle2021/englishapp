const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizRightWord = new Schema({
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson',  },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.RIGHT_PRONOUNCE },
  wordId: { type: Schema.Types.ObjectId, ref: 'Word',  },
  correctChoice: { type: String },
  firstChoice: { type: String, required: true },
  secondChoice: { type: String },
  thirdChoice: { type: String },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizRightWord.plugin(populatePlugin);
quizRightWord.plugin(timestampPlugin);

module.exports = mongoose.model('QuizRightWord', quizRightWord, 'quizzesRightWord');
