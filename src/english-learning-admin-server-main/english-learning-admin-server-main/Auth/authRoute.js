const authController = require("./authController");
const express = require("express");
const router = express.Router();
const { ROUTES } = require("../routes/constant");

router.post(
  ROUTES.AUTH.LOGIN,
  async (req, res, next) => {
    try {
      console.log(req.body);
      const { username, password } = req.body;
      const { isMatch, user } = await authController.login(username, password);
      if (!isMatch) {
        res.send({
          error: "Wrong username or password"
        })
      } else {
        req.user = user;
        next();
      }
    } catch (error) {
      res.send(error.message);
    }
  },
  authController.signToken
);

module.exports = router;
