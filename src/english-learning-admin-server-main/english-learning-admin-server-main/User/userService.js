const mongoose = require("mongoose");
const User = require("./userModel");

// Get all user
const getAllUsers = async (options) => {
  let { isDeleted } = options;
  if (isDeleted === undefined) {
    isDeleted = false;
  }
  const filter = {
    isDeleted: isDeleted,
    userType:"ADMIN"
  };
  return await User.find(filter);
};

// Get user by userid
const getUserById = async (userId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(userId),
  };
  return await User.findOne(filter);
};

// search user
const searchUser = async (queryObj) => {
  return await User.find(queryObj);
};

// Add new user
const addUser = async (data) => {
  console.log('Admin user data: ', data);
  const user = await User.findOne({ username: data.username });
  if (user) {
    return "The username has been existed";
  }
  const newUser = new User(data);
  return await newUser.save();
};

// Update user
const updateUser = async (userId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(userId),
  };
  const options = {
    new: true,
    upsert: false,
  };
  return await User.findOneAndUpdate(filter, data, options);
};

// Delete all users
const deleteAllUsers = async () => {
  return await User.deleteMany({});
};

// Delete user by id
const deleteUserById = async (userId) => {
  const filter = {
      _id: mongoose.Types.ObjectId(userId)
  }

  return await User.deleteOne(filter)
  // return await updateUser(userId, {});
};

module.exports = {
  getAllUsers,
  getUserById,
  searchUser,
  addUser,
  updateUser,
  deleteAllUsers,
  deleteUserById,
};
