const configuration = require('../configs');

const ObjectToArray = (object) => {
  const result = [];
  Object.values(object).map((value) => {
    result.push(value);
  });
  return result;
};

const isQuizTypeValid = ( quizType ) => {
  return ObjectToArray(configuration.quizTypes).includes(quizType);
};

const isUserTypeValid = (userType) => {
  if(userType === configuration.userTypes.SYSTEM_ADMIN){
    return true;
  }
  return false;
  // return ObjectToArray(configuration.userTypes).includes(userType);
};

const isLevelTypeValid = (levelType) => {
  return ObjectToArray(configuration.levelTypes).includes(levelType);
};

module.exports = {
  isQuizTypeValid,
  ObjectToArray,
  isUserTypeValid,
  isLevelTypeValid
};
