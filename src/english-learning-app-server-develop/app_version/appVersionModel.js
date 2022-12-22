const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const Schema = mongoose.Schema;

const AppVersionSchema = new Schema({
  appVersion: {
    type: String,
    default: "0"
  },
  isDeleted: { type: Boolean, default: false, required: true }
});

AppVersionSchema.plugin(timestampPlugin);


module.exports = mongoose.model(
  "AppVersion",
  AppVersionSchema,
  "app_version"
);
