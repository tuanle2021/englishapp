const assert = require('assert');
const isNil = require('lodash/fp/isNil');
const { REVIEW_OUTCOME } = require('../shares/constant');

const validate = (object) => {
  for (const property in object) {
    assert.deepStrictEqual(isNil(object[property]), false,`${property} is invalid`);
  }
};

const betweenMinMax = (value, min, max) => {
  if (max && value > max) {
    return max;
  }
  if (min && value < min) {
    return min;
  }
  return value;
};

const getCurrentTimeString = () => {
  const currentdate = new Date();
  return 'Last: ' + currentdate.getDate() + '/'
    + (currentdate.getMonth() + 1) + '/'
    + currentdate.getFullYear() + ' @ '
    + currentdate.getHours() + ':'
    + currentdate.getMinutes() + ':'
    + currentdate.getSeconds();
};

// in second
const getCurrentTime = () => {
  return Math.round(new Date().getTime() / 1000);
};

const secondToDayHourMinuteString = (sec) => {
  const t = sec * 1000; // second to millisecond
  const cd = 24 * 60 * 60 * 1000;
  const ch = 60 * 60 * 1000;
  let d = Math.floor(t / cd);
  let h = Math.floor( (t - d * cd) / ch);
  let m = Math.round( (t - d * cd - h * ch) / 60000);
  const pad = function(n) { return n < 10 ? '0' + n : n; };

  if ( m === 60 ) {
    h++;
    m = 0;
  }
  if ( h === 24 ) {
    d++;
    h = 0;
  }
  return [d, pad(h), pad(m)].join(':');
};

const phaseToString = (phase) => {
  switch (phase) {
  case 0:
    return 'Learn';
  case 1:
    return 'Review'; // Graduated
  case 2:
    return 'Relearn';
  default:
    return 'invalid phase';
  }
};

const getRateName = (rating) => {
  switch (rating) {
  case REVIEW_OUTCOME.AGAIN:
    return 'Again';
  case REVIEW_OUTCOME.HARD:
    return 'Hard';
  case REVIEW_OUTCOME.GOOD:
    return 'Good';
  case REVIEW_OUTCOME.EASY:
    return 'Easy';
  default:
    return 'invalid rating';
  }
};

module.exports = {
  validate,
  betweenMinMax,
  getCurrentTime,
  getCurrentTimeString,
  secondToDayHourMinuteString,
  phaseToString,
  getRateName
};
