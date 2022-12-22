const mongoose = require('mongoose');
const timestampPlugin = require('../shares/plugins/timestamp');
const populatePlugin = require('mongoose-autopopulate');

const options = {
  versionKey: false
};

const subCategorySchema = new mongoose.Schema({
  name: { type: String, required: true },
  category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category',  },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

subCategorySchema.plugin(populatePlugin);
subCategorySchema.plugin(timestampPlugin);

module.exports = mongoose.model('SubCategory', subCategorySchema, 'subCategories');
