const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const Schema = mongoose.Schema;
const populatePlugin = require("mongoose-autopopulate");

const options = {
  versionKey: false
}

const FeedbackSchema = new Schema({
  userId: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    default: null,
    autopopulate: true,
    required: true
  },
  content: {
    type: String,
    required: true
  },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

FeedbackSchema.plugin(timestampPlugin);
FeedbackSchema.plugin(populatePlugin);

module.exports = mongoose.model(
  "Feedback",
  FeedbackSchema,
  "feedbacks"
);
