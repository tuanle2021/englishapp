const mongoose = require("mongoose");
const timestampPlugin = require("../shares/plugins/timestamp");
const populatePlugin = require("mongoose-autopopulate");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema(
  {
    username: { type: String, required: true },
    password: { type: String, required: true },
    userType: { type: String, required: true },
    name: { type: String, required: true },
    isLock: { type: Boolean, default: false },
    isDeleted: { type: Boolean, default: false },
  },
  {
    versionKey: false,
  }
);

userSchema.plugin(timestampPlugin);
userSchema.plugin(populatePlugin);

// Hash password
userSchema.pre("save", function (next) {
  const user = this;

  // only hash the password if it has been modified (or is new)
  if (!user.isModified("password")) {
    return next();
  }

  // generate a salt
  bcrypt.genSalt(10, function (err, salt) {
    if (err) return next(err);

    // hash the password using our new salt
    bcrypt.hash(user.password, salt, function (err, hash) {
      if (err) return next(err);
      // override the cleartext password with the hashed one
      user.password = hash;
      next();
    });
  });
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  const isMatch = bcrypt.compare(candidatePassword, this.password);
  return isMatch;
};

module.exports = mongoose.model("User", userSchema, "user_admin");
