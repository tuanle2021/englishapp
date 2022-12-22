const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");
const SubCategory = require('../SubCategory/subCategoryModel')

const options = {
  versionKey: false,
};

const lessonSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    subCategoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "SubCategory",
     
    },
    isDeleted: { type: Boolean, default: false, required: true },
  },
  options
);

lessonSchema.plugin(populatePlugin);
lessonSchema.plugin(timestampPlugin);

module.exports = mongoose.model("Lesson", lessonSchema, "lessons");
