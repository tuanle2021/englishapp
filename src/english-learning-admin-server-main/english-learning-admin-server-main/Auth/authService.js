const jwt = require("jsonwebtoken");
const User = require("../User/userModel");

// Issue Token
const signToken = (req, res) => {
  try {
    if (!req.user) {
      return res.status(401).send({ error: "User was not authenticated" });
    }
    const payload = {
      userId: req.user._id,
      username: req.user.username,
      userType: req.user.userType,
    };
    jwt.sign(
      payload,
      process.env.MY_SECRET_KEY,
      { expiresIn: "600 min" },
      (err, token) => {
        if (err) {
          res.sendStatus(500);
        } else {
          console.log(`Verified: ${req.user.username}---${req.user.userType}`);
          res.json({
            user: req.user,
            access_token: token,
          });
        }
      }
    );
  } catch (error) {
    res.send(error.message);
  }
};

// check if Token exists on request Header and attach token to request as attribute
const checkToken = (req, res, next) => {
  try {
    // Get auth header value
    const bearerHeader = req.headers.authorization;
    if (typeof bearerHeader !== "undefined") {
      req.token = bearerHeader.split(" ")[1];

      jwt.verify(req.token, process.env.MY_SECRET_KEY, (err, authData) => {
        if (err) {
          res.sendStatus(403);
        } else {
          if (
            authData.userType !== "ADMIN" &&
            authData.userType !== "SYSTEM_ADMIN"
          ) {
            res.sendStatus(403);
          } else {
            req.authData = authData;
            next();
          }
        }
      });
    } else {
      // if (process.env.FONTEND_LOGIN) {
      //   res.redirect(process.env.FONTEND_LOGIN);
      // } else {
      //   res.sendStatus(403);
      // }
      res.sendStatus(403);
    }
  } catch (error) {
    res.send(error.message);
  }
};

const login = async (username, password) => {
  const user = await User.findOne({ username: username });
  if (user) {
    const isMatch = await user.comparePassword(password);
    return {
      isMatch: isMatch,
      user: user
    }
  } else {
    return {
      isMatch: false,
      user: null
    }
  }
};

module.exports = {
  signToken,
  checkToken,
  login,
};
