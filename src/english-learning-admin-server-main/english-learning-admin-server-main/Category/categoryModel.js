const mongoose = require('mongoose');
const timestampPlugin = require('../shares/plugins/timestamp');

const options = {
  versionKey: false
};

const catSchema = new mongoose.Schema({
  name: { type: String, default: '' },
  levelType: { type: String },
  isDeleted: { type: Boolean, default: false, required: true },
  image: {type: String}
}, options);

catSchema.plugin(timestampPlugin);

module.exports = mongoose.model('Category', catSchema, 'categories');
