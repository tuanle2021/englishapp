const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../../shares/plugins/timestamp');

const options = {
  versionKey: false
};

const quizTypeSchema = new Schema({
  name: { type: String, default: '' },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

quizTypeSchema.plugin(timestampPlugin);

module.exports = mongoose.model('QuizType', quizTypeSchema, 'quizTypes');
