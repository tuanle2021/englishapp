const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");
const Schema = mongoose.Schema;

const options = {
  versionKey: false
};

const userFavouriteSchema = new Schema({
  userId: {
    type: mongoose.Types.ObjectId,
    ref: "User"
  },
  wordId: {
    type: mongoose.Types.ObjectId,
    ref: "Word"
  }
}, options);

userFavouriteSchema.plugin(timestampPlugin);
userFavouriteSchema.plugin(populatePlugin);

module.exports = mongoose.model(
  "UserFavourite",
  userFavouriteSchema,
  "user_favourite"
);
