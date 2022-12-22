const mongoose = require('mongoose');
const SubCategory = require('./subcategoryModel');
const assert = require('assert');

// Get all
const getAllSubCategories = async () => {
  const options = {
    isDeleted: false
  };

  return await SubCategory.find(options);
};

// Get by id
const getSubCategoryById = async (subCategoryId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(subCategoryId),
    isDeleted: false
  };
  return await SubCategory.findOne(filter);
};

// search
const searchSubCategory = async (queryObj) => {
  return await SubCategory.find(queryObj);
};

// Add new
const addSubCategory = async (data) => {
  const { name, category } = data;
  assert.notEqual(name, undefined);
  assert.notEqual(category, undefined);

  const newSubCategory = new SubCategory(data);
  return await newSubCategory.save();
};

// Update
const updateSubCategory = async (subCategoryId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(subCategoryId),
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await SubCategory.findOneAndUpdate(filter, data, options);
};

// Delete all
const deleteAllSubCategories = async () => {
  return await SubCategory.deleteMany({});
};

// Delete by id
const deleteSubCategoryById = async (subCategoryId) => {
  return await updateSubCategory(subCategoryId, {
    isDeleted: true
  })
};

module.exports = {
  getAllSubCategories,
  getSubCategoryById,
  searchSubCategory,
  addSubCategory,
  updateSubCategory,
  deleteAllSubCategories,
  deleteSubCategoryById
};
