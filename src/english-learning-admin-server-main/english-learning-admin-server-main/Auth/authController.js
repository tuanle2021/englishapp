const async = require('hbs/lib/async');
const authService = require('./authService');

const login = async (username, password) => {
  return await authService.login(username, password);
};

const signToken = (req, res) => {
  authService.signToken(req, res);
};

const checkToken = (req, res, next) => {
  authService.checkToken(req, res, next);
};

module.exports = {
  login,
  signToken,
  checkToken
};
