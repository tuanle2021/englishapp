const mongoose = require('mongoose');
const get = require('lodash/fp/get');

const Logger = require('./userCardLoggerModel');


const addLog = async (data) => {
  const cardId = get('cardId')(data);
  const date = get('date')(data);
  const type = get('type')(data);
  const rating = get('rating')(data);
  const interval = get('interval')(data);
  const ease = get('ease')(data);

  const newLogger = new Logger({
    cardId: mongoose.Types.ObjectId(cardId),
    date,
    type,
    rating,
    interval,
    ease
  });

  return await newLogger.save();
}

module.exports = {
  addLog
};
