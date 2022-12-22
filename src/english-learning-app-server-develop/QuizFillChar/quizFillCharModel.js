const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizFillChar = new Schema({
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson',  },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.FILL_CHAR },
  wordId: { type: Schema.Types.ObjectId, ref: 'Word',  },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizFillChar.plugin(populatePlugin);
quizFillChar.plugin(timestampPlugin);

module.exports = mongoose.model('QuizFillChar', quizFillChar, 'quizzesFillChar');
