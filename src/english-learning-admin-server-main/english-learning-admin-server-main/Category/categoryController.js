const catService = require("./categoryService");

const getAllCategories = async () => {
  return await catService.getAllCategories();
};

const searchCategory = async (queryObj) => {
  return await catService.searchCategory(queryObj);
};

const getCategory = async ({ id }) => {
  return await catService.getCategoryById(id);
};

const addCategory = async (data) => {
  return await catService.addCategory(data);
};

const updateCategoryField = async (catId, newData) => {
  return await catService.updateCategoryField(catId, newData);
};

const deleteAllCategories = async () => {
  return await catService.deleteAllCategories();
};

const deleteCategoryById = async ({ id }) => {
  return await catService.deleteCategoryById(id);
};

module.exports = {
  getAllCategories,
  getCategory,
  addCategory,
  updateCategoryField,
  deleteAllCategories,
  deleteCategoryById,
  searchCategory
};
