const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");

const wordSchema = new Schema({
  word_id: {
    type: String,
    default: "",
  },
  word: {
    type: String,
    default: "",
  },
  lexicalCategory: {
    type: String,
    default: null,
  },
  type: {
    type: String,
    default: null,
  },
  ori_lang: {
    type: String,
    default: null,
  },
  tra_lang: {
    type: String,
    default: null,
  },
  definitions: {
    type: String,
    default: null,
  },
  shortDefinitions: {
    type: String,
    default: null,
  },
  examples: {
    type: String,
    default: null,
  },
  phoneticNotation: {
    type: String,
    default: null,
  },
  phoneticSpelling: {
    type: String,
    default: null,
  },
  audioFile: {
    type: String,
    default: null,
  },
  synonyms: {
    type: String,
    default: null,
  },
  phrases: {
    type: String,
    default: null,
  },
  mean: {
    type: String,
    default: null,
  },
  category: {
    type: String,
    default: null,
  },
  level: {
    type: String,
    default: null,
  },
});

wordSchema.plugin(timestampPlugin);
wordSchema.plugin(populatePlugin);

module.exports = mongoose.model("Word", wordSchema);
