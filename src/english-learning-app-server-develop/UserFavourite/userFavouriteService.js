const mongoose = require('mongoose');
const UserFavourite = require('./userFavouriteModel');
const Word = require('../words/wordModel')
const User = require('../User/userModel')
const assert = require('assert');

const getAllUserFavourites = async () => {
  const filter = {
    isDeleted: false
  };

  return await UserFavourite.find(filter);
};

// Get UserFavourite by UserFavourite id
const getUserFavouriteById = async (userFavouriteId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(userFavouriteId),
    isDeleted: false
  };
  return await UserFavourite.findOne(filter);
};

const getUserFavouriteByUserId = async (userId) => {
  return await UserFavourite.find({userId: mongoose.Types.ObjectId(userId)})
}

// search UserFavourite
const searchUserFavourite = async (queryObj) => {
  return await UserFavourite.find(queryObj);
};

// Add new UserFavourite
const addUserFavourite = async (data) => {
  const { userId, wordId } = data;
  assert.notEqual(userId, undefined);
  assert.notEqual(wordId, undefined);
  const user = await User.findOne(mongoose.Types.ObjectId(userId))
  const word = await Word.findOne(mongoose.Types.ObjectId(wordId))
  if (!user || !word) {
    return {
      error: "User hoac Word khong ton tai"
    }
  }

  const newUserFavourite = new UserFavourite(data);
  await newUserFavourite.save()
  return newUserFavourite;
};

// Update UserFavourite
const updateUserFavourite = async (userFavouriteId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(userFavouriteId),
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await UserFavourite.findOneAndUpdate(filter, data, options);
};

const deleteAllUserFavourites = async () => {
  return await UserFavourite.deleteMany({});
};

// Delete UserFavourite by id
const deleteUserFavouriteById = async (userFavouriteId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(userFavouriteId)
  // }
  // return await UserFavourite.deleteOne(filter)

  return await updateUserFavourite(userFavouriteId, {
    isDeleted: true
  });
};

module.exports = {
  getAllUserFavourites,
  getUserFavouriteById,
  getUserFavouriteByUserId,
  searchUserFavourite,
  addUserFavourite,
  updateUserFavourite,
  deleteAllUserFavourites,
  deleteUserFavouriteById
};
