const mongoose = require('mongoose');
const CategoryUser = require('./categoryUserModel');
const assert = require('assert');
const User = require('../User/userModel')
const Category = require('../Category/categoryModel')

const getAllCategoryUsers = async () => {
  const filter = {
    isDeleted: false
  };

  return await CategoryUser.find(filter);
};

// Get CategoryUser by CategoryUser id
const getCategoryUserById = async (categoryUserId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(categoryUserId),
    isDeleted: false
  };
  return await CategoryUser.findOne(filter);
};

// search CategoryUser
const searchCategoryUser = async (queryObj) => {
  return await CategoryUser.find(queryObj);
};

// Add new CategoryUser
const addCategoryUser = async (data) => {
  const { userId, categoryId } = data;
  assert.notEqual(userId, undefined);
  assert.notEqual(categoryId, undefined);
  const user = await User.findOne(userId)
  const category = await Category.findOne(categoryId)
  if (!user || !category) {
    return {
      error: "User hoac Cate khong ton tai"
    }
  }

  const newCategoryUser = new CategoryUser(data);
  return await newCategoryUser.save();
};

// Update CategoryUser
const updateCategoryUser = async (categoryUserId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(categoryUserId),
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await CategoryUser.findOneAndUpdate(filter, data, options);
};

const deleteAllCategoryUsers = async () => {
  return await CategoryUser.deleteMany({});
};

// Delete CategoryUser by id
const deleteCategoryUserById = async (categoryUserId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(categoryUserId)
  // }
  // return await CategoryUser.deleteOne(filter)

  return await updateCategoryUser(categoryUserId, {
    isDeleted: true
  });
};

module.exports = {
  getAllCategoryUsers,
  getCategoryUserById,
  searchCategoryUser,
  addCategoryUser,
  updateCategoryUser,
  deleteAllCategoryUsers,
  deleteCategoryUserById
};
