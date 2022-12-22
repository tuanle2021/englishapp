const { QUIZ_TYPES, USER_TYPES, LEVEL_TYPES } = require('./constant');

class Configuration {
  constructor() {
    this.quizTypes = QUIZ_TYPES;
    this.userTypes = USER_TYPES;
    this.levelTypes = LEVEL_TYPES;
  }
}

const configuration = new Configuration();
module.exports = configuration;
