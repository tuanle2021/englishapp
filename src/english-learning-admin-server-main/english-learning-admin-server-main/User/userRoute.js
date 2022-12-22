const express = require('express');
const router = express.Router();
const userController = require('./userController');
const { ROUTES } = require('../routes/constant');
const isNil = require('lodash/fp/isNull');
const { isUserTypeValid } = require('../shares/stringUtils');
const authService = require('../Auth/authService');
const configuration = require('../configs');
// Authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.USER.GET_ALL, async (req, res) => {
  try {
    const options = req.query;
    const result = await userController.getAllUser(options);
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});


// search user
router.get(ROUTES.USER.GET_BY_FIELD_ID, async (req, res) => {
  try {
    const { search_field, search_value } = req.query;
    const queryObj = {};

    if (!isNil(search_field) && !isNil(search_value)) {
      queryObj[search_field] = search_value;
    }

    const result = await userController.searchUser(queryObj);
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});


// get user by id
router.get(ROUTES.USER.GET_BY_ID, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await userController.getUserById(id);
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});

// Add user
router.post(ROUTES.USER.CREATE_ONE, async (req, res) => {
  try {
    let newUser = req.body;
    let result = {};

    if (newUser.userType === undefined) {
      result = await userController.addUser(newUser);
    } else {
      if (isUserTypeValid(newUser.userType)) {
        newUser.userType = configuration.userTypes.ADMIN;
        result = await userController.addUser(newUser);
      }
    }
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});

// Update user
router.post(ROUTES.USER.UPDATE_BY_ID, async (req, res) => {
  try {
    const { id } = req.params;
    let updateData = req.body;
    let result = {};
    if (updateData.userType === undefined) {
      updateData.userType = configuration.userTypes.ADMIN;
      result = await userController.updateUser(id, updateData);
    } else {
      if (isUserTypeValid(updateData.userType)) {
        updateData.userType = configuration.userTypes.ADMIN;
        result = await userController.updateUser(id, updateData);
      }
    }
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});

// Delete all user
router.get(ROUTES.USER.DELETE_ALL, async (req, res) => {
  try {
    const result = await userController.deleteAllUser();
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});

// Delete user by id
router.get(ROUTES.USER.DELETE_BY_ID, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await userController.deleteUserById(id);
    res.send(result);
  } catch (error) {
    res.send(error.message);
  }
});

module.exports = router;
