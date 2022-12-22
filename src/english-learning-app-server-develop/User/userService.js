const User = require("./userModel");
const mongoose = require("mongoose");
const userFavouriteModel = require("../UserFavourite/userFavouriteModel");
const lessonUserModel = require("../LessonUser/lessonUserModel");
const categoryUserModel = require("../CategoryUser/categoryUserModel");
const lessonUserScoreModel = require("../LessonUserScore/lessonUserScoreModel");
const { updateUserData } = require("../services/synchronizeService");
const userModel = require("./userModel");

const profile = async (req) => {
  return { statusCode: 200, result: req.user };
};


const updateProfile = async (id, firstName, lastName, photoUrl,facebookId,googleId,authStrategy,isSharedData) => {
  const user = await User.findOne({
    _id: mongoose.Types.ObjectId(id),
  });
  console.log(id)
  if (user) {
    user.firstName = firstName;
    user.lastName = lastName;
    user.photoUrl = photoUrl;
    user.authStrategy = authStrategy;
    user.facebookId = facebookId;
    user.googleId = googleId;
    user.isSharedData = isSharedData;

    const result = await user.save();
    if (result) {
      return {success:true,userProfile:result}
    }
    else {
      return {success:false}
    }
  }
};
const checkExistEmail = async (email) => {
  const user = await User.findOne({username: email })
  if (user) {
    console.log(user)
    return {valid: true}
  }
  else {
    return {valid: false}
  }
}

const fetchUserData = async(userId) => {
  await updateUserData();
  const user_favourite = await userFavouriteModel.find({userId: userId})
  const lesson_user = await lessonUserModel.find({userId: userId})
  const category_user = await categoryUserModel.find({userId: userId})
  const lesson_user_score = await lessonUserScoreModel.find({userId: userId})
  const result = {
    user_favourite: user_favourite,
    lesson_user:lesson_user,
    category_user:category_user,
    lesson_user_score:lesson_user_score,
   
  }
  return result;
}

const updatePassword = async (email, newPassword) => {
  const filter = {
    username: email
  }
  const user = await User.findOne(filter)
  if (!user) {
    return {statusCode: 500, result: 'Email khong hop le'}
  } else {
    await user.setPassword(newPassword)
    await user.save()
    return {statusCode: 200, result: user}
  }
}

module.exports = {
  profile: profile,
  updateProfile: updateProfile,
  updatePassword: updatePassword,
  checkExistEmail: checkExistEmail,
  fetchUserData: fetchUserData
};
