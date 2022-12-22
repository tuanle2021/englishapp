const express = require("express");
const router = express.Router();
const User = require("../User/userModel");
const passport = require("passport");
const {
  getToken,
  COOKIE_OPTIONS,
  getRefreshToken,
  verifyUser,
} = require("../authenticate/authenticate");

const nodemailer = require("nodemailer");
const authService = require("../services/authService");
const jwt = require("jsonwebtoken");
const ActivationCode = require("./activationCodeModel");
const { ROUTES, VERSION } = require("../routes/constant");
const Category = require("../Category/categoryModel");
const CategoryUser = require("../CategoryUser/categoryUserModel");
const categoryUserService = require("../CategoryUser/categoryUserService");
const Lesson = require("../Lesson/lessonModel");
const LessonUser = require("../LessonUser/lessonUserModel");
const lessonUserService = require("../LessonUser/lessonUserService");
const { compareCate, compareLess } = require("../shares/arrayUtils");
const handleError = require("../shares/handleError");
const { createUserData, updateUserData } = require("../services/synchronizeService");
const LessonUserScore = require("../LessonUserScore/lessonUserScoreModel");
const { default: mongoose } = require("mongoose");
const userFavouriteModel = require("../UserFavourite/userFavouriteModel");
const lessonUserScoreModel = require("../LessonUserScore/lessonUserScoreModel");

router.post(
  `/${VERSION}${ROUTES.AUTH.REFRESH_TOKEN}`,
  handleError((req, res, next) => {
    const refreshToken = req.body.refreshToken;
    if (refreshToken) {
      try {
        const payload = jwt.verify(
          refreshToken,
          process.env.REFRESH_TOKEN_SECRET
        );
        const userId = payload._id;
        User.findOne({ _id: userId }).then(
          (user) => {
            if (user) {
              // Find the refresh token against the user record in database
              const tokenIndex = user.refreshToken.findIndex(
                (item) => item.refreshToken === refreshToken
              );

              if (tokenIndex === -1) {
                res.statusCode = 401;
                res.send("Unauthorized");
              } else {
                const token = getToken({ _id: userId });
                console.log(token);
                // If the refresh token exists, then create new one and replace it.
                const newRefreshToken = getRefreshToken({ _id: userId });
                user.refreshToken[tokenIndex] = {
                  refreshToken: newRefreshToken,
                };
                user.save((err, user) => {
                  if (err) {
                    res.statusCode = 500;
                    res.send(err);
                  } else {
                    res.send({
                      success: true,
                      accessToken: token,
                      refreshToken: {
                        refreshToken: newRefreshToken,
                        expiry: Date.now() + 1209600000,
                      },
                    });
                  }
                });
              }
            } else {
              res.statusCode = 401;
              res.send("Unauthorized");
            }
          },
          (err) => next(err)
        );
      } catch (err) {
        res.statusCode = 401;
        res.send("Unauthorized");
      }
    } else {
      res.statusCode = 401;
      res.send("Unauthorized");
    }
  })
);

//...
router.post(
  `/${VERSION}${ROUTES.AUTH.SIGNUP}`,
  handleError((req, res, next) => {
    // Verify that first name is not empty
    if (!req.body.firstName) {
      res.statusCode = 500;
      res.send({
        name: "FirstNameError",
        message: "The first name is required",
      });
    } else {
      User.register(
        new User({ username: req.body.email }),
        req.body.plainPassword,
        async (err, user) => {
          if (err) {
            res.statusCode = 500;
            res.send({ error: err });
          } else {
            user.email = req.body.email;
            user.firstName = req.body.firstName;
            user.lastName = req.body.lastName || "";
            const token = getToken({ _id: user._id });
            const refreshToken = getRefreshToken({ _id: user._id });
            user.refreshToken.push({ refreshToken });

            await createUserData(user);

            user.save((err, user) => {
              if (err) {
                res.statusCode = 500;
                res.send({ error: err });
              } else {
                res.statusCode = 200;
                res.send({ success: true });
              }
            });
          }
        }
      );
    }
  })
);



router.post(`/${VERSION}${ROUTES.AUTH.LINK_FACEBOOK}`,verifyUser,passport.authenticate("linkingFacebook", {
  session:false,
  scope: ["profile","email"]
}), authService.linkingAccount)

router.post(`/${VERSION}${ROUTES.AUTH.LINK_GOOGLE}`,verifyUser,passport.authenticate("linkingGoogle", {
  session:false,
  scope: ["profile","email"]
}), authService.linkingAccount)

router.post(
  `/${VERSION}${ROUTES.AUTH.GOOGLE_TOKEN}`,
  passport.authenticate("google-token", {
    session: false,
    scope: ["profile", "email"],
  }),
  authService.signToken
);
router.post(
  `/${VERSION}${ROUTES.AUTH.FACEBOOK_TOKEN}`,
  passport.authenticate("facebook-token", {
    session: false,
    scope: ["profile", "email","user_friends"],
  }),
  authService.signToken
);

router.post(
  `/${VERSION}${ROUTES.AUTH.VERIFY_ACTIVATION_CODE}`,
  passport.authenticate("local"),
  handleError(async (req, res, next) => {
    const findActCode = await ActivationCode.findOne({
      Email: req.user.username,
    });
    if (findActCode != null && findActCode != undefined) {
      if (findActCode.Code == req.body.code) {
        validateLogin(req, res, true);
      } else {
        res.statusCode(500);
        res.send({ error: "Activation code is not correct", notCorrect: true });
      }
    } else {
      res.statusCode(500);
      res.send({ error: "Can't not find activation code", notFound: true });
    }
  })
);

router.post(
  `/${VERSION}${ROUTES.AUTH.SEND_ACTIVATION_CODE}`,
  passport.authenticate("local"),
  handleError(async (req, res, next) => {
    console.log(req.body);
    let actAlreadyCode = await ActivationCode.findOne({
      Email: req.body.email,
    });
    if (actAlreadyCode != null && actAlreadyCode != undefined) {
      await actAlreadyCode.delete();
    }
    const code = new ActivationCode({
      Email: req.body.email,
    });

    const gmail = process.env.Mail;
    const password = process.env.passwordMail;

    code.save((err, code) => {
      if (err) {
        res.statusCode = 500;
        res.send({ error: err });
      } else {
        const smtpTransport = nodemailer.createTransport({
          service: "gmail",
          host: "smtp.gmail.com",
          auth: {
            user: gmail,
            pass: password,
          },
        });
        const mailOptions = {
          from: gmail,
          to: req.body.email,
          subject: "[MyVocal Activation Account]",
          text: "Your code is " + code.Code,
        };
        console.log(code);
        smtpTransport.sendMail(mailOptions, (error, response) => {
          if (error) {
            res.status(503);
            res.send({
              success: false,
              error: error,
            });
          } else {
            res.status(200);
            res.send({
              success: true,
            });
          }
          error ? console.log(error) : console.log(response);
          smtpTransport.close();
        });
      }
    });
  })
);

function validateLogin(req, res, activateAccount = false) {
  const token = getToken({ _id: req.user._id });
  const refreshToken = getRefreshToken({ _id: req.user._id });
  User.findById(req.user._id).then(
    async (user) => {
      if (!user.isActivated) {
        user.isActivated = activateAccount;
      }
      if (user.isActivated == false) {
        res.send({ success: true, isActivated: false });
        return;
      }
      await updateUserData(user._id)
      user.refreshToken.push({ refreshToken });
      user.save(async (err, user) => {
        if (err) {
          res.statusCode = 500;
          res.send({ error: err });
        } else {
          const categogy_user = await CategoryUser.find({
            userId: req.user._id,
          });
          const lesson_user = await LessonUser.find({ userId: req.user._id });
          const user_favourite = await userFavouriteModel.find({userId: req.user._id})
          const lesson_user_score = await lessonUserScoreModel.find({userId: req.user._id})
          const result = {
            userProfile: user,
            success: true,
            accessToken: token,
            refreshToken: {
              refreshToken: refreshToken,
              expiry: Date.now() + 1209600000,
            },
            category_user: categogy_user,
            lesson_user: lesson_user,
            user_favourite: user_favourite,
            lesson_user_score: lesson_user_score
          };
          console.log(categogy_user)
          res.send(result);
        }
      });
    },
    (err) => next(err)
  );
}

router.post(
  `/${VERSION}${ROUTES.AUTH.LOGIN}`,
  passport.authenticate("local"),
  handleError((req, res, next) => {
    console.log(req.body);
    validateLogin(req, res);
  })
);

router.post(
  `/v1/test`,
  verifyUser,
  handleError(async (req, res, next) => {
    next();
  })
);

router.post(
  "/v1/test-reset",
  handleError(async (req, res) => {
    await User.deleteOne({ email: "test-user" });
    await CategoryUser.deleteMany({ userId: "6288e2e110a62da14d465cb3" });
    await LessonUser.deleteMany({ userId: "6288e2e110a62da14d465cb3" });
    res.send("Success");
  })
);

module.exports = router;
