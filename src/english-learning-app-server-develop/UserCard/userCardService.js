const mongoose = require('mongoose');
const get = require('lodash/fp/get');

const {
  validate,
  betweenMinMax,
  getCurrentTime,
  getCurrentTimeString,
  secondToDayHourMinuteString,
  phaseToString,
  getRateName
} = require('./utils');
const {
  REVIEW_OUTCOME,
  PHASE,
  NEW_CARD,
  LAPSE,
  INTERVAL,
  EASE
} = require('../shares/constant');
const UserCard = require('./userCardModel');
const UserStatisticService = require('../Statistic/statisticService');
const { addLog } = require('../UserCardLogger/userCardLoggerService');

const getAll = async () => {
  const filter = {
    isDeleted: false
  };

  return await UserCard.find(filter);
};

const getById = async (reqQuery) => {
  const search_field = get('search_field')(reqQuery);
  const search_value = get('search_value')(reqQuery);
  validate({ search_field, search_value });

  const queryObj = {};
  queryObj[search_field] = mongoose.Types.ObjectId(search_value);
  queryObj.isDeleted = false;

  return await UserCard.find(queryObj);
};

const getByProp = async (reqQuery) => {
  const search_field = get('search_field')(reqQuery);
  const search_value = get('search_value')(reqQuery);
  validate({ search_field, search_value });

  const queryObj = {};
  queryObj[search_field] = search_value;
  queryObj.isDeleted = false;

  return await UserCard.find(queryObj);
};

const createOne = async (data) => {
  const wordId = get('wordId')(data);
  const userId = get('userId')(data);

  validate({
    wordId,
    userId,
  });

  const query = {
    wordId: mongoose.Types.ObjectId(wordId),
    userId: mongoose.Types.ObjectId(userId),
    isDeleted: false
  };

  const record = await UserCard.findOne(query);

  if (record) {
    throw Error('This flashcard has already been saved');
  } else {
    const newUserCard = new UserCard({
      wordId,
      userId
    });

    return await Promise.all([
      newUserCard.save(),
      UserStatisticService.createOrUpdateUserStatistic(userId)
    ]);
  }
};

const userReview = async (reqBody) => {
  const cardId = get('cardId')(reqBody);
  const rating = get('rating')(reqBody);
  validate({
    cardId,
    rating
  });

  const data = (await getById({
    search_field: '_id',
    search_value: cardId
  }))[0];

  if (!data) {
    throw Error('Flashcard not found');
  }

  let curr_phase = get('phase')(data);
  let curr_interval = get('interval')(data);
  let original_interval = get('original_interval')(data);
  let curr_ease = get('ease')(data);
  let curr_due = get('due')(data);
  let curr_step = get('step')(data);
  const userId = get('userId')(data);
  validate({
    curr_phase,
    curr_interval,
    curr_ease,
    curr_due,
    curr_step,
    original_interval,
    userId
  });

  await UserStatisticService.updateStatisticByRating({
    userId: userId.toString(),
    rating,
    interval: curr_interval,
    phase: curr_phase
  });

  const modifier = await UserStatisticService.getModifier(userId.toString());

  if (curr_phase === PHASE.LEARNING) {
    switch(rating) {
    case REVIEW_OUTCOME.AGAIN:
      curr_step = 0;
      curr_interval = NEW_CARD.LEARNING_STEP[curr_step];
      break;
    case REVIEW_OUTCOME.HARD:
      if (curr_step === NEW_CARD.LEARNING_STEP.length - 1) {
        curr_interval = NEW_CARD.LEARNING_STEP[NEW_CARD.LEARNING_STEP.length - 1];
      } else {
        curr_interval = (NEW_CARD.LEARNING_STEP[curr_step] + NEW_CARD.LEARNING_STEP[curr_step + 1]) / 2;
      }
      break;
    case REVIEW_OUTCOME.GOOD:
      if (curr_step === NEW_CARD.LEARNING_STEP.length - 1) {
        curr_phase = PHASE.GRADUATED;
        curr_step = 0;
        curr_interval = NEW_CARD.GRADUATING_INTERVAL;
      } else {
        curr_step += 1;
        curr_interval = NEW_CARD.LEARNING_STEP[curr_step];
      }
      break;
    case REVIEW_OUTCOME.EASY:
      curr_phase = PHASE.GRADUATED;
      curr_step = 0;
      curr_interval = NEW_CARD.EASY_INTERVAL;
      break;
    }
  } else if (curr_phase === PHASE.GRADUATED) {
    switch(rating) {
    case REVIEW_OUTCOME.AGAIN:
      curr_ease -= 0.2;
      curr_phase = PHASE.RELEARNING;
      original_interval = curr_interval;
      curr_interval = LAPSE.RELEARNING_STEP[0];
      break;
    case REVIEW_OUTCOME.HARD:
      curr_ease -= 0.15;
      curr_interval *= INTERVAL.HARD * modifier;
      break;
    case REVIEW_OUTCOME.GOOD:
      curr_interval *= curr_ease * modifier;
      break;
    case REVIEW_OUTCOME.EASY:
      curr_ease += 0.15;
      curr_interval *= curr_ease * modifier * EASE.BONUS;
      break;
    }
  } else { // relearning phase
    switch(rating) {
    case REVIEW_OUTCOME.AGAIN:
      curr_step = 0;
      curr_interval = LAPSE.RELEARNING_STEP[curr_step];
      break;
    case REVIEW_OUTCOME.HARD:
      // curr_step may be used
      curr_interval *= INTERVAL.HARD_RELEARNING * LAPSE.RELEARNING_STEP[0]; // TODO: not sure 0 or current step?
      break;
    case REVIEW_OUTCOME.GOOD:
      // curr_step may be used
      curr_interval = original_interval * INTERVAL.NEW;
      curr_interval = betweenMinMax(curr_interval, LAPSE.MIN_INTERVAL);
      break;
    case REVIEW_OUTCOME.EASY:
      curr_phase = PHASE.GRADUATED;
      curr_step = 0;
      curr_interval = (original_interval * INTERVAL.NEW) + 1;
      break;
    }
  }

  curr_interval = betweenMinMax(curr_interval, INTERVAL.MIN, INTERVAL.MAX);
  curr_ease = betweenMinMax(curr_ease, EASE.MIN);
  curr_ease = Math.round((curr_ease + Number.EPSILON) * 100) / 100 // JS bi khung: 2.8 + 0.15 = 2.9499999999999997 ???
  curr_due = getCurrentTime() + curr_interval;

  const filter = { _id: mongoose.Types.ObjectId(cardId) };

  const update = {
    ease: curr_ease,
    interval: curr_interval,
    step: curr_step,
    due: curr_due,
    phase: curr_phase,
    original_interval
  };

  await Promise.all([
    UserCard.findOneAndUpdate(filter, update),
    addLog({
      cardId,
      date: getCurrentTimeString(),
      type: phaseToString(curr_phase),
      rating: getRateName(rating),
      interval: secondToDayHourMinuteString(curr_interval),
      ease: curr_ease
    })
  ]);

  return {
    succeeded: true
  };
};

const getDue = async (reqParam) => {
  const userId = get('userid')(reqParam);
  validate({ userId });
  const curr_time = getCurrentTime();

  const filter = {
    userId: mongoose.Types.ObjectId(userId),
    isDeleted: false,
    $or: [
      {
        $and: [{ due: { $lte: curr_time } }, { due: { $gt: 0 } }]  // overdue
      },
      {
        $and: [{ due: 0 }, { interval: 0 }] // recently added
      }
    ]
  };

  return await UserCard.find(filter);
};

module.exports = {
  getAll,
  getById,
  getByProp,
  createOne,
  userReview,
  getDue
};
