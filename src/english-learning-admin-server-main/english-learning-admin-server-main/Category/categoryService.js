const mongoose = require('mongoose');
const assert = require('assert');
const { create, read, update, del } = require('./categoryDAL');
const Category = require('./categoryModel');

// create
const addCategory = async (data) => {
  const { name, levelType, image } = data;
  assert.notEqual(name, undefined);
  assert.notEqual(levelType, undefined);

  const newCat = new Category({
    name,
    levelType,
    image
  });

  return await create(newCat);
};

// read
const getAllCategories = async () => {
  return await read();
};
const getCategoryById = async (catId) => {
  const options = {
    _id: mongoose.Types.ObjectId(catId)
  };

  return await read(options);
};

// search category
const searchCategory = async (queryObj) => {
  return await Category.find(queryObj);
};

// update
const updateCategoryField = async (catId, newData) => {
  const options = {
    catId: mongoose.Types.ObjectId(catId),
    newData
  };

  return await update(options);
};

// delete
const deleteAllCategories = async () => {
  return await del();
};

const deleteCategoryById = async (catId) => {
  return await updateCategoryField(catId, {
    isDeleted: true
  });
};

module.exports = {
  addCategory,
  getAllCategories,
  getCategoryById,
  updateCategoryField,
  deleteAllCategories,
  deleteCategoryById,
  searchCategory
};
