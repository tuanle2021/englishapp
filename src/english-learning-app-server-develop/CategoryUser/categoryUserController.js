const categoryUserService = require('./categoryUserService');

const getAllCategoryUser = async () => {
  return await categoryUserService.getAllCategoryUsers();
};

const getCategoryUserById = async (categoryUserId) => {
  return await categoryUserService.getCategoryUserById(categoryUserId);
};

const searchCategoryUser = async (queryObj) => {
  return await categoryUserService.searchCategoryUser(queryObj);
};

const addCategoryUser = async (data) => {
  return await categoryUserService.addCategoryUser(data);
};

const updateCategoryUser = async (categoryUserId, data) => {
  return await categoryUserService.updateCategoryUser(categoryUserId, data);
};

const deleteAllCategoryUser = async () => {
  return await categoryUserService.deleteAllCategoryUsers();
};

const deleteCategoryUserById = async (categoryUserId) => {
  return await categoryUserService.deleteCategoryUserById(categoryUserId);
};

module.exports = {
  getAllCategoryUser,
  getCategoryUserById,
  searchCategoryUser,
  addCategoryUser,
  updateCategoryUser,
  deleteAllCategoryUser,
  deleteCategoryUserById
};
