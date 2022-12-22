const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const Schema = mongoose.Schema;
const populatePlugin = require("mongoose-autopopulate");

const LessonUserSchema = new Schema({
  totalIncorrect: {
    type: Number,
    default: 0,
  },
  totalCorrect: {
    type: Number,
    default: 0,
  },
  point: {
    type: Number,
    default: 0
  },
  completionTime: {
    type: String,
    default: "0",
  },
  completedAt: {
    type: Date,
    default: Date.now(),
  },
  accuracy: {
    type: Number,
    default: 0
  },
  lessonId: {
    type: mongoose.Types.ObjectId,
    ref: "Lesson",
    default: null
  },
  userId: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    default: null
  },
  isDeleted: { type: Boolean, default: false, required: true }
});

LessonUserSchema.plugin(timestampPlugin);
LessonUserSchema.plugin(populatePlugin);

module.exports = mongoose.model("LessonUserScore", LessonUserSchema, "lesson_user_score");
