const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const categoryUserController = require('./categoryUserController');
const { VERSION, ROUTES } = require('../routes/constant');
const wrap = require('../shares/handleError');

const { verifyUser } = require('../authenticate/authenticate')

// authenticate
router.all('*', verifyUser);

// get all
// router.get(`/${VERSION}${ROUTES.CATEGORY_USER.GET_ALL}`, wrap(async (req, res) => {
//   const result = await categoryUserController.getAllCategoryUser();
//   res.send(result);
// }));

// search category
router.get(`/${VERSION}${ROUTES.CATEGORY_USER.GET_BY_FIELD_ID}`, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await categoryUserController.searchCategoryUser(queryObj);
  res.send(result);
}));

// get category by id
router.get(`/${VERSION}${ROUTES.CATEGORY_USER.GET_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await categoryUserController.getCategoryUserById(id);
  res.send(result);
}));

// Add category
router.post(`/${VERSION}${ROUTES.CATEGORY_USER.CREATE_ONE}`, wrap(async (req, res) => {
  const result = await categoryUserController.addCategoryUser(req.body);
  res.send(result);
}));

// Update category
router.post(`/${VERSION}${ROUTES.CATEGORY_USER.UPDATE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;

  const result = await categoryUserController.updateCategoryUser(id, updateData);
  res.send(result);
}));

// Delete all category
router.get(`/${VERSION}${ROUTES.CATEGORY_USER.DELETE_ALL}`, wrap(async (req, res) => {
  const result = await categoryUserController.deleteAllCategoryUser();
  res.send(result);
}));

// Delete category by id
router.get(`/${VERSION}${ROUTES.CATEGORY_USER.DELETE_BY_ID}`, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await categoryUserController.deleteCategoryUserById(id);
  res.send(result);
}));

module.exports = router;
