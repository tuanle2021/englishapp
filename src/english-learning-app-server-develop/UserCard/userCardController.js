const userCardService = require('./userCardService');

const getAll = async () => {
  return await userCardService.getAll();
};

const getCardsById = async (reqQuery) => {
  return await userCardService.getById(reqQuery);
};

const getCardsByValue = async (reqQuery) => {
  return await userCardService.getByProp(reqQuery);
};

const createOne = async (reqBody) => {
  return await userCardService.createOne(reqBody);
};

const userReview = async (reqBody) => {
  return await userCardService.userReview(reqBody);
};

const getUserDueCards = async (reqParams) => {
  return await userCardService.getDue(reqParams);
};

module.exports = {
  getAll,
  getCardsByValue,
  getCardsById,
  createOne,
  userReview,
  getUserDueCards
}
