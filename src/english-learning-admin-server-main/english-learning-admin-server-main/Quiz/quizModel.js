const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');

const options = {
  versionKey: false
};

const quizSchema = new Schema({
  quiz_type: { type: Schema.Types.ObjectId, ref: 'QuizType', autopopulate: true },
  quiz_id: { type: Schema.Types.ObjectId },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizSchema.plugin(timestampPlugin);
quizSchema.plugin(populatePlugin);

module.exports = mongoose.model('Quiz', quizSchema, 'quizzes');
