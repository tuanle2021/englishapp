const mongoose = require('mongoose')
  , Schema = mongoose.Schema;
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');

const options = {
  versionKey: false
};

const wordSchema = new Schema({
  word_id: { type: String, default: '' },
  word: { type: String, default: '' },
  lexicalCategory: { type: String, default: '' },
  type: { type: String, default: '' },
  ori_lang: { type: String, default: '' },
  tra_lang: { type: String, default: '' },
  definitions: { type: String, default: '' },
  shortDefinitions: { type: String, default: '' },
  examples: { type: String, default: '' },
  phoneticNotation: { type: String, default: 'IPA' },
  phoneticSpelling: { type: String, default: '' },
  audioFile: { type: String, default: '' },
  synonyms: { type: String, default: '' },
  phrases: { type: String, default: '' },
  mean: { type: String, default: '' },
  category: { type: Schema.Types.ObjectId, ref: 'Category', autopopulate: true },
  levelType: { type: String },
  isDeleted: { type: Boolean, default: false, required: true },
  image: { type: String }
}, options);

wordSchema.plugin(populatePlugin);
wordSchema.plugin(timestampPlugin);

module.exports = mongoose.model('Word', wordSchema, 'words');
