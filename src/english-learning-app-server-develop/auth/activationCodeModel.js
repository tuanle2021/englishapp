const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const actCode = require("../common/utils");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");

const activationCodeSchema = new Schema({
  Email: {
    type: String,
    default: null,
  },
  Code: {
    type: String,
    default: actCode.makeId(5),
  },
  Expired: {
    type: Number,
    default: Date.now() + 900000,
  },
});

activationCodeSchema.plugin(timestampPlugin);
activationCodeSchema.plugin(populatePlugin);

module.exports = mongoose.model("ActivationCode", activationCodeSchema);
