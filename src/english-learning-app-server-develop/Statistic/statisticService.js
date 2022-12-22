const mongoose = require('mongoose');
const get = require('lodash/fp/get');
const isEmpty = require('lodash/fp/isEmpty');

const {
  MATURE_CARD_COUNT,
  REVIEW_OUTCOME,
  PHASE,
  INTERVAL,
  IDEAL_RETENTION
} = require('../shares/constant');
const UserStatisticModel = require('./statisticModel');
const UserCard = require('../UserCard/userCardModel');

const findUserStatistic = async (userId) => {
  const filter = {
    userId: mongoose.Types.ObjectId(userId),
    isDeleted: false
  };

  return (await UserStatisticModel.find(filter))[0]; // sure that only a user get a statistic
};

const getTrueRetention = async (userId) => {
  const record = await findUserStatistic(userId);

  if (record.passedReviews === 0 && record.flunkedReviews === 0) {
    return -1;
  }

  return record.passedReviews / (record.passedReviews + record.flunkedReviews);
};

const createOrUpdateUserStatistic = async (userId) => {
  const record = await findUserStatistic(userId);

  if (record) {
    record.totalCards += 1;
    return await record.save();
  }

  const newUserStatistic = new UserStatisticModel({
    userId: mongoose.Types.ObjectId(userId),
    totalCards: 1
  });

  return await newUserStatistic.save();
};

const getAllMatureCards = async (userId) => {
  const filter = {
    userId: mongoose.Types.ObjectId(userId),
    interval: { $gte: INTERVAL.MATURE_CARD_THRESHOLD },
    isDeleted: false
  };
  return await UserCard.find(filter);
}

const getModifier = async (userId) => {
  await updateModifier(userId);

  const userStat = await UserStatisticModel.findOne({
    userId: mongoose.Types.ObjectId(userId),
    isDeleted: false
  });

  return get('modifier')(userStat);
};

const updateModifier = async (userId) => {
  const userMatureCards = await getAllMatureCards(userId);

  if (isEmpty(userMatureCards) || userMatureCards.length < MATURE_CARD_COUNT) {
    return;
  }

  const retention = await getTrueRetention(userId);

  if (retention === -1 || retention === 1 || retention === 0) {
    return;
  }

  let idealRetention;
  if (retention < IDEAL_RETENTION.MIN) {
    idealRetention = IDEAL_RETENTION.MIN;
  }
  else if (retention > IDEAL_RETENTION.MAX) {
    idealRetention = IDEAL_RETENTION.MAX;
  }
  else {
    return;
  }

  const record = await findUserStatistic(userId);
  const newModifier = Math.abs(record.modifier * Math.log(idealRetention) / Math.log(retention));

  if (Math.abs(newModifier - record.modifier) > 0.2) {
    return;
  }
  record.modifier = newModifier;
  return await record.save();
};

const updateStatisticByRating = async({ userId, rating, interval, phase }) => {
  const record = await findUserStatistic(userId);

  switch(rating) {
    case REVIEW_OUTCOME.AGAIN:
      record.againReviews += 1;
      if (phase === PHASE.GRADUATED && interval > INTERVAL.MATURE_CARD_THRESHOLD) {
        record.flunkedReviews += 1;
      }
      break;
    case REVIEW_OUTCOME.HARD:
      record.hardReviews += 1;
      if (phase === PHASE.GRADUATED && interval > INTERVAL.MATURE_CARD_THRESHOLD) {
        record.passedReviews += 1;
      }
      break;
    case REVIEW_OUTCOME.GOOD:
      record.goodReviews += 1;
      if (phase === PHASE.GRADUATED && interval > INTERVAL.MATURE_CARD_THRESHOLD) {
        record.passedReviews += 1;
      }
      break;
    case REVIEW_OUTCOME.EASY:
      record.easyReviews += 1;
      if (phase === PHASE.GRADUATED && interval > INTERVAL.MATURE_CARD_THRESHOLD) {
        record.passedReviews += 1;
      }
      break;
  }

  return await record.save();
};


module.exports = {
  createOrUpdateUserStatistic,
  getModifier,
  getTrueRetention,
  updateStatisticByRating
}
