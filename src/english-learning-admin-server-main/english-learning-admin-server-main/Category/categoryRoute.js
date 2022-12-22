const express = require('express');
const router = express.Router();
const assert = require('assert');
const multer = require('multer');
const upload = multer({ dest: 'public/tmp/' });
const fs = require('fs');

const catController = require('./categoryController');
const { ROUTES } = require('../routes/constant');
const { isLevelTypeValid } = require('../shares/stringUtils');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');
const catModel = require('./categoryModel');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('category');
});

// get all categories
router.get(ROUTES.CATEGORY.GET_ALL, wrap(async (req, res) => {
  const data = await catController.getAllCategories();
  res.send(data);
}));


// search lesson
router.get(ROUTES.CATEGORY.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await catController.searchCategory(queryObj);
  res.send(result);
}));


// get category by id
router.get(ROUTES.CATEGORY.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const data = await catController.getCategory({ id });
  res.send(data);
}));

// create a category
router.post(ROUTES.CATEGORY.CREATE_ONE, upload.single('categoryImage'), wrap(async (req, res) => {
  const file = req.file
  if (file) {
    const img = fs.readFileSync(req.file.path)
    const encode_image = img.toString('base64')
    req.body.image = encode_image
  }
  const { levelType } = req.body;
  assert.notEqual(levelType, undefined);
  let result = {};

  if (isLevelTypeValid(levelType)) {
    result = await catController.addCategory(req.body);
  }

  res.send(result);
}));

// update a category field by id
router.post(ROUTES.CATEGORY.UPDATE_BY_ID, upload.single('categoryImage'), wrap(async (req, res) => {
  const { id } = req.params;
  const cat = await catModel.findOne({_id: id});
 
  const file = req.file;
  if (file) {
    console.log(file);
    const img = fs.readFileSync(req.file.path);

    const encode_image = img.toString('base64');
    req.body.image = encode_image;
  }else{
    req.body.image = cat.image;
  }

  assert.notEqual(id, undefined);


  const result = await catController.updateCategoryField(id, req.body);
  res.send(result);
}));

// delete all categories
router.get(ROUTES.CATEGORY.DELETE_ALL, wrap(async (req, res) => {
  const result = await catController.deleteAllCategories();
  res.send(result);
}));

// delete a category by id
router.get(ROUTES.CATEGORY.DELETE_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const result = await catController.deleteCategoryById({ id });
  res.send(result);
}));

module.exports = router;
