const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const { ROUTES } = require('../routes/constant');
const subCategoryController = require('./subCategoryController');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.SUB_CATEGORY.GET_ALL, wrap(async (req, res) => {
  const result = await subCategoryController.getAllSubCategories();
  res.send(result);
}));

// search
router.get(ROUTES.SUB_CATEGORY.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await subCategoryController.searchSubCategory(queryObj);
  res.send(result);
}));

// get by id
router.get(ROUTES.SUB_CATEGORY.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await subCategoryController.getSubCategoryById(id);
  res.send(result);
}));

// Add
router.post(ROUTES.SUB_CATEGORY.CREATE_ONE, wrap(async (req, res) => {
  const result = await subCategoryController.addSubCategory(req.body);
  res.send(result);
}));

// Update
router.post(ROUTES.SUB_CATEGORY.UPDATE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;

  const result = await subCategoryController.updateSubCategory(id, updateData);
  res.send(result);
}));

// Delete all
router.get(ROUTES.SUB_CATEGORY.DELETE_ALL, wrap(async (req, res) => {
  const result = await subCategoryController.deleteAllSubCategories();
  res.send(result);
}));

// Delete by id
router.get(ROUTES.SUB_CATEGORY.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await subCategoryController.deleteSubCategoryById(id);
  res.send(result);
}));

module.exports = router;
