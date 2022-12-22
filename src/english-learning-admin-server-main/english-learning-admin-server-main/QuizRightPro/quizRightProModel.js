const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizRightPronounce = new Schema({
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson', autopopulate: true },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.RIGHT_PRONOUNCE },
  wordId: { type: Schema.Types.ObjectId, ref: 'Word', autopopulate: true },
  wordIdOne: { type: Schema.Types.ObjectId, ref: 'Word', autopopulate: true },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizRightPronounce.plugin(populatePlugin);
quizRightPronounce.plugin(timestampPlugin);

module.exports = mongoose.model('QuizRightPronounce', quizRightPronounce, 'quizzesRightPronounce');
