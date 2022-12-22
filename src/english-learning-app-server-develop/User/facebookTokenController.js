const facebookTokenService = require("./facebookTokenService");

const getFriendListByUserId = async (userId) => {
  return await facebookTokenService.getFriendListByUserId(userId);
};

const getFriendScoreByUserId = async (userId) => {
  return await facebookTokenService.getFriendScoreByUserId(userId);
};

const getAllFacebookToken = async () => {
  return await facebookTokenService.getAllFacebookTokens();
};

const getFacebookTokenById = async (facebookTokenId) => {
  return await facebookTokenService.getFacebookTokenById(facebookTokenId);
};

const searchFacebookToken = async (queryObj) => {
  return await facebookTokenService.searchFacebookToken(queryObj);
};

const addFacebookToken = async (data) => {
  return await facebookTokenService.addFacebookToken(data);
};

const updateFacebookToken = async (facebookTokenId, data) => {
  return await facebookTokenService.updateFacebookToken(facebookTokenId, data);
};

const deleteAllFacebookToken = async () => {
  return await facebookTokenService.deleteAllFacebookTokens();
};

const deleteFacebookTokenById = async (facebookTokenId) => {
  return await facebookTokenService.deleteFacebookTokenById(facebookTokenId);
};

module.exports = {
  getFriendListByUserId,
  getFriendScoreByUserId,
  getAllFacebookToken,
  getFacebookTokenById,
  searchFacebookToken,
  addFacebookToken,
  updateFacebookToken,
  deleteAllFacebookToken,
  deleteFacebookTokenById,
};
