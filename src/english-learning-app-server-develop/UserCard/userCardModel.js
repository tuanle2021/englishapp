const mongoose = require('mongoose');

const timestampPlugin = require('../shares/plugins/timestamp');
const { PHASE } = require('../shares/constant');

const options = {
  versionKey: false
};

const userCardSchema = new mongoose.Schema({
  wordId: { type: mongoose.Schema.Types.ObjectId, ref: 'Word' },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  phase: { type: Number, default: PHASE.LEARNING },
  interval: { type: Number, default: 0 }, // unit: second
  original_interval: { type: Number, default: 0 }, // for relearning phase
  ease: { type: Number, default: 2.5 },
  due: { type: Number, default: 0 }, // unit: second
  step: { type: Number, default: 0 },
  isDeleted: { type: Boolean, default: false, required: true }
}, options);

userCardSchema.plugin(timestampPlugin);

module.exports = mongoose.model('UserCard', userCardSchema, 'userCards');
