const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizTransArrange = new Schema({
  wordId: { type: Schema.Types.ObjectId, ref: 'Word',  },
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson',  },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.TRANS_ARRANGE },
  originSentence: { type: String, default: '', required: true },
  viSentence: { type: String, default: '', required: true },
  viPhrase: { type: [String], default: [], required: true },
  isDeleted: { type: Boolean, default: false, required: true },
  numRightPhrase: {type: Number, default: 0}
}, options);

quizTransArrange.plugin(populatePlugin);
quizTransArrange.plugin(timestampPlugin);

module.exports = mongoose.model('QuizTransArrange', quizTransArrange, 'quizzesTransArrange');
