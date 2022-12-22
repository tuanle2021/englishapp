const userService = require('./userService');

const getAllUser = async (options) => {
  return await userService.getAllUsers(options);
};

const getUserById = async (userId) => {
  return await userService.getUserById(userId);
};

const searchUser = async (queryObj) => {
  return await userService.searchUser(queryObj);
};

const addUser = async (data) => {
  return await userService.addUser(data);
};

const updateUser = async (userId, data) => {
  return await userService.updateUser(userId, data);
};

const deleteAllUser = async () => {
  return await userService.deleteAllUsers();
};

const deleteUserById = async (userId) => {
  return await userService.deleteUserById(userId);
};

module.exports = {
  getAllUser,
  getUserById,
  searchUser,
  addUser,
  updateUser,
  deleteAllUser,
  deleteUserById
};
