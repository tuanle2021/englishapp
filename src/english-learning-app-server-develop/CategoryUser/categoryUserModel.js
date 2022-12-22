const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");
const Schema = mongoose.Schema;

const CategoryUserSchema = new Schema({
  userId: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    default: null
  },
  categoryId: {
    type: mongoose.Types.ObjectId,
    ref: "Category",
    default: null,
    
  },
  progress: {
    type: Number,
    default: 0
  },
  isDeleted: {
    type: Boolean,
    default: false
  },
  isBlock: {
    type: Boolean,
    default: true
  },
  isComplete: {
    type: Boolean,
    default: false
  }
});

CategoryUserSchema.plugin(timestampPlugin);
CategoryUserSchema.plugin(populatePlugin);

module.exports = mongoose.model(
  "CategoryUser",
  CategoryUserSchema,
  "category_user"
);
