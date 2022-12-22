const userFavouriteService = require('./userFavouriteService');

const getAllUserFavourite = async () => {
  return await userFavouriteService.getAllUserFavourites();
};

const getUserFavouriteById = async (userFavouriteId) => {
  return await userFavouriteService.getUserFavouriteById(userFavouriteId);
};

const searchUserFavourite = async (queryObj) => {
  return await userFavouriteService.searchUserFavourite(queryObj);
};

const getUserFavouriteByUserId = async(userId) => {
  return await userFavouriteService.getUserFavouriteByUserId(userId);
}

const addUserFavourite = async (data) => {
  return await userFavouriteService.addUserFavourite(data);
};

const updateUserFavourite = async (userFavouriteId, data) => {
  return await userFavouriteService.updateUserFavourite(userFavouriteId, data);
};

const deleteAllUserFavourite = async () => {
  return await userFavouriteService.deleteAllUserFavourites();
};

const deleteUserFavouriteById = async (userFavouriteId) => {
  return await userFavouriteService.deleteUserFavouriteById(userFavouriteId);
};

module.exports = {
  getAllUserFavourite,
  getUserFavouriteById,
  getUserFavouriteByUserId,
  searchUserFavourite,
  addUserFavourite,
  updateUserFavourite,
  deleteAllUserFavourite,
  deleteUserFavouriteById
};
