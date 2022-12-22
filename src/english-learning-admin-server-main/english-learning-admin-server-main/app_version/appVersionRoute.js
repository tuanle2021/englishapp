const express = require('express');
const router = express.Router();
const isNil = require('lodash/fp/isNull');

const { ROUTES } = require('../routes/constant');
const appVersionController = require('./appVersionController');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.APPVERSION.GET, wrap(async (req, res) => {
  const result = await appVersionController.getappVersion();
  
  res.send(result);
}));


// Update
router.post(ROUTES.APPVERSION.UPDATE, wrap(async (req, res) => {
  const updateData = req.body;

  const result = await appVersionController.updateappVersion( updateData);
  res.send(result);
}));



module.exports = router;
