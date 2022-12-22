const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const Schema = mongoose.Schema;
const populatePlugin = require("mongoose-autopopulate");

const options = {
  versionKey: false,
};

const facebookTokenModel = new Schema(
  {
    userId: {
      type: mongoose.Types.ObjectId,
      autopopulate: true,
      unique: true,
      ref: 'User'
    },
    accessToken: {
      type: String,
    },
    refreshToken: {
      type: String,
    },
    isDeleted: {
      type: Boolean,
      default: false
    }
  },
  options
);

facebookTokenModel.plugin(timestampPlugin);
facebookTokenModel.plugin(populatePlugin);

module.exports = mongoose.model("FacebookToken", facebookTokenModel);
