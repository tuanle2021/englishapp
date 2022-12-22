const jwt = require("jsonwebtoken");
const User = require("../User/userModel");
const {
  getToken,
  COOKIE_OPTIONS,
  getRefreshToken,
} = require("../authenticate/authenticate");

const handleError = require('../shares/handleError')
const CategoryUser = require("../CategoryUser/categoryUserModel");
const LessonUser = require("../LessonUser/lessonUserModel");
const { default: mongoose } = require("mongoose");
const userFavouriteModel = require("../UserFavourite/userFavouriteModel");
const { updateUserData } = require("./synchronizeService");
const lessonUserScoreModel = require("../LessonUserScore/lessonUserScoreModel");

// Issue Token

exports.linkingAccount = handleError((req, res) => {
  if (req.body.isHasOtherUser) {
    res.send({success:false,isHasOtherUser: true})
  }
  else {
    res.send({success:true,userProfile: req.user})

  }

});

exports.signToken = handleError((req, res) => {
  if (!req.user) {
    return res.status(404).send({ error: "User was not authenticated" });
  }

  const userId = req.user._id;
  console.log(req.body);
  User.findOne({ _id: req.user._id }).then(
    async (user) => {
      if (user) {
        // Find the refresh token against the user record in database
        const token = getToken({ _id: userId });
        // If the refresh token exists, then create new one and replace it.
        const newRefreshToken = getRefreshToken({ _id: userId });

        user.refreshToken = [{ refreshToken: newRefreshToken }];
        if (!user.deviceId.includes(req.body.device_id)) {
          user.deviceId.push(req.body.device_id);
        }
        await updateUserData(user._id);

        user.save(async (err, user) => {
          if (err) {
            res.statusCode = 500;
            res.send({ error: err });
          } else {
            const category_user = await CategoryUser.find({userId: user._id})
            const lesson_user =  await LessonUser.find({userId: user._id})
            const lesson_user_score = await lessonUserScoreModel.find({userId: user._id})
            const user_favourite = await userFavouriteModel.find({userId: user._id})
            res.send({
              success: true,
              userProfile: user,
              category_user: category_user,
              lesson_user: lesson_user,
              accessToken: token,
              user_favourite: user_favourite,
              lesson_user_score: lesson_user_score,
              refreshToken: {
                refreshToken: newRefreshToken,
                expiry: Date.now() + 1209600000,
              },
            });
          }
        });
      } else {
        res.statusCode = 401;
        res.send("Unauthorized");
      }
    },
    (err) => next(err)
  );
});
