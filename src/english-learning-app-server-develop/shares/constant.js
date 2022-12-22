const REVIEW_OUTCOME = Object.freeze({
  AGAIN: 0,
  HARD: 1,
  GOOD: 2,
  EASY: 3
});

const PHASE = Object.freeze({
  LEARNING: 0, // learn card
  GRADUATED: 1, // review card
  RELEARNING: 2 // relearn card
});

/**
 * unit in second
 */
const NEW_CARD = Object.freeze({
  LEARNING_STEP: [300, 1200, 86400], // 5m, 20m, 1d
  GRADUATING_INTERVAL: 259200, // 3d
  EASY_INTERVAL: 345600 // 4d
});

const LAPSE = Object.freeze({
  RELEARNING_STEP: [600], // 10m
  MIN_INTERVAL: 86400, // 1d
  LEECH_THRESHOLD: 8,
  ACTION: 'NONE'
});

// General
const INTERVAL = Object.freeze({
  // MAX: 31536000, // 365d
  MAX: 8035200, // 3months
  MIN: 60, // 1m
  HARD: 1.2,
  HARD_RELEARNING: 1.5,
  NEW: 0.2,
  MATURE_CARD_THRESHOLD: 1814400 // 21d
});

const EASE = Object.freeze({
  START: 2.5,
  MIN: 1.3,
  MAX: 2.5,
  BONUS: 1.3
});

const MATURE_CARD_COUNT = 50;

const IDEAL_RETENTION = Object.freeze({
  MIN: 0.85,
  MAX: 0.9
});

module.exports = {
  REVIEW_OUTCOME,
  PHASE,
  NEW_CARD,
  LAPSE,
  INTERVAL,
  EASE,
  MATURE_CARD_COUNT,
  IDEAL_RETENTION
};
