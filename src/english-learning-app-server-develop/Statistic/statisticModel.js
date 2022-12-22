const mongoose = require('mongoose');
const timestampPlugin = require('../shares/plugins/timestamp');

const options = {
  versionKey: false
};

const statisticSchema = new mongoose.Schema({
  userId: { type: mongoose.Types.ObjectId },
  modifier: { type: Number, default: 1 },
  passedReviews: { type: Number, default: 0 }, // for mature & review card (to calculate retention rate)
  flunkedReviews: { type: Number, default: 0 }, // for mature & review card (to calculate retention rate)
  againReviews: { type: Number, default: 0 },
  goodReviews: { type: Number, default: 0 },
  easyReviews: { type: Number, default: 0 },
  hardReviews: { type: Number, default: 0 },
  // totalCards: { type: Number, default: 0 },
  // learnCards: { type: Number, default: 0 },
  // relearnCards: { type: Number, default: 0 },
  // reviewCards: { type: Number, default: 0 },
  // firstReview: {},
  // latestReview: {}
  isDeleted: { type: Boolean, default: false }
}, options);

statisticSchema.plugin(timestampPlugin);

module.exports = mongoose.model('Statistic', statisticSchema, 'Statistics');
