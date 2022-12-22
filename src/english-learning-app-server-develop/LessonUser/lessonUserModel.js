const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const Schema = mongoose.Schema;
const populatePlugin = require("mongoose-autopopulate");

const LessonUserSchema = new Schema({
  userId: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    default: null,
  },
  lessonId: {
    type: mongoose.Types.ObjectId,
    ref: "Lesson",
    default: null,
  },
  isBlock: {
    type: Boolean,
    default: true,
  },
  isCompleted: {
    type: Boolean,
    default: false,
  },
  isDeleted: { type: Boolean, default: false, required: true }
});

LessonUserSchema.plugin(timestampPlugin);
LessonUserSchema.plugin(populatePlugin);

module.exports = mongoose.model(
  "LessonUser",
  LessonUserSchema,
  "lesson_user"
);
