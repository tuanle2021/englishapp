const mongoose = require('mongoose');

const options = {
  versionKey: false
};

const userCardLoggerSchema = new mongoose.Schema({
  cardId: { type: mongoose.Schema.Types.ObjectId },
  date: { type: String },
  type: { type: String },
  rating: { type: String },
  interval: { type: String },
  ease: { type: Number }
}, options);

module.exports = mongoose.model('UserCardLogger', userCardLoggerSchema, 'userCardLoggers');
