const subCategoryService = require('./subCategoryService');

const getAllSubCategories = async () => {
  return await subCategoryService.getAllSubCategories();
};

const getSubCategoryById = async (subCategoryId) => {
  return await subCategoryService.getSubCategoryById(subCategoryId);
};

const searchSubCategory = async (queryObj) => {
  return await subCategoryService.searchSubCategory(queryObj);
};

const addSubCategory = async (data) => {
  return await subCategoryService.addSubCategory(data);
};

const updateSubCategory = async (subCategoryId, data) => {
  return await subCategoryService.updateSubCategory(subCategoryId, data);
};

const deleteAllSubCategories = async () => {
  return await subCategoryService.deleteAllSubCategories();
};

const deleteSubCategoryById = async (subCategoryId) => {
  return await subCategoryService.deleteSubCategoryById(subCategoryId);
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
