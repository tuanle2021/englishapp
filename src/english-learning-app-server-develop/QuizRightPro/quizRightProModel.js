const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');
const Configuration = require('../configs/index');

const options = {
  versionKey: false
};

const quizRightPronounce = new Schema({
  lessonId: { type: Schema.Types.ObjectId, ref: 'Lesson',  },
  name: { type: String, default: '' },
  type: { type: String, default: Configuration.quizTypes.RIGHT_WORD },
  wordId: { type: Schema.Types.ObjectId, ref: 'Word',  },
  wordIdOne: { type: Schema.Types.ObjectId, ref: 'Word',  },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizRightPronounce.plugin(populatePlugin);
quizRightPronounce.plugin(timestampPlugin);

module.exports = mongoose.model('QuizRightPronounce', quizRightPronounce, 'quizzesRightPronounce');
