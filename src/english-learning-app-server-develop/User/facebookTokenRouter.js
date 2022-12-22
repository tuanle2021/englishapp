const express = require("express");
const router = express.Router();
const isNil = require("lodash/fp/isNull");

const facebookTokenController = require("./facebookTokenController");
const { VERSION, ROUTES } = require("../routes/constant");
const wrap = require("../shares/handleError");

const { verifyUser } = require("../authenticate/authenticate");
const { encodeXText } = require("nodemailer/lib/shared");

// authenticate
router.all("*", verifyUser);

// Get friend list
router.get(
  `/${VERSION}${ROUTES.FACEBOOK_TOKEN.GET_FRIEND_LIST}`,
  wrap(async (req, res) => {
    const userId = req.user._id;
    const result = await facebookTokenController.getFriendListByUserId(userId);
    res.send(result);
    // res.send(userId);
  })
);

// Get friend score
router.get(
  `/${VERSION}${ROUTES.FACEBOOK_TOKEN.GET_FRIEND_SCORE}`,
  wrap(async (req, res, next) => {
    const userId = req.user._id;
    const result = await facebookTokenController.getFriendScoreByUserId(userId);
    res.send(result);
  })
);

module.exports = router;
