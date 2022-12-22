const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const passportLocalMongoose = require("passport-local-mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");

const Session = new Schema({
  refreshToken: {
    type: String,
    default: "",
  },
});

const userSchema = new Schema({
  firstName: {
    type: String,
    default: "",
  },
  lastName: {
    type: String,
    default: "",
  },
  authStrategy: {
    type: String,
    default: "local",
  },
  email: {
    type: String,
    default: "",
    unique: true
  },
  deviceId: {
    type: [String],
    default: null,
  },
  refreshToken: {
    type: [Session],
  },
  googleId: {
    type: String,
    default: "",
  },
  facebookId: {
    type: String,
    default: "",
  },
  otpNumber: {
    type: String,
    default: "",
  },
  isActive: {
    type: Boolean,
    default: true,
  },
  isLock: {
    type: Boolean,
    default: false,
  },
  createdTime: {
    type: Date,
    default: () => Date.now(),
  },
  authStrategy: {
    type: String,
    default: "local",
  },
  email: {
    type: String,
    default: "",
  },
  deviceId: {
    type: [String],
    default: "",
  },
  isActivated: {
    type: Boolean,
    default: false,
  },

  isSharedData: {
    type: Boolean,
    default: false,
  },

  refreshToken: {
    type: [Session],
  },
  photoUrl: {
    type: String,
    default: null,
  },
  mainAuthStrategy: {
    type: String,
    default: "local"
  },
  
});

//Remove refreshToken from the response
userSchema.set("toJSON", {
  transform: function (doc, ret, options) {
    delete ret.refreshToken;
    return ret;
  },
});

userSchema.plugin(populatePlugin);
userSchema.plugin(timestampPlugin);
userSchema.plugin(passportLocalMongoose);

module.exports = mongoose.model("User", userSchema);
