const mongoose = require("mongoose");
const FacebookToken = require("./facebookTokenModel");
const assert = require("assert");
const User = require("./userModel");
const axios = require("axios");
const lessonUserScoreService = require("../LessonUserScore/lessonUserScoreService");
const { createLogger } = require("winston");
const { compareScore } = require('../shares/arrayUtils')



// Filter list friend
const filterFriendList = async (data) => {
  const friendList = [];
  for (let i = 0; i < data.length; i++) {
    const facebookId = data[i].id;
    const user = await User.findOne({ facebookId: facebookId });
    if (user) {
      friendList.push(user);
    }
  }
  return friendList;
};

// Get friend list
const getFriendListByUserId = async (userId) => {
  const filter = {
    userId: mongoose.Types.ObjectId(userId),
  };
  const user = await User.findOne({ _id: mongoose.Types.ObjectId(userId) });
  const facebookToken = await FacebookToken.findOne(filter);
  const facebookId = facebookToken.userId.facebookId;
  const accessToken = facebookToken.accessToken;
  if (!facebookToken || !facebookId || !accessToken) {
    return {
      error: "facebook token || facebookId || accessToken khong ton tai",
    };
  }
  const reqResult = await axios.get(
    `https://graph.facebook.com/${facebookId}/friends?access_token=${accessToken}`
  );
  const friendList = await filterFriendList(reqResult.data.data);
  friendList.push(user);
  console.log(friendList);
  return friendList;
};

const getFriendScoreByUserId = async (userId) => {
  const filter = {
    userId: mongoose.Types.ObjectId(userId),
  };
  const user = await User.findOne({ _id: mongoose.Types.ObjectId(userId) });
  const facebookToken = await FacebookToken.findOne(filter);
  const facebookId = facebookToken.userId.facebookId;
  const accessToken = facebookToken.accessToken;
  if (!facebookToken || !facebookId || !accessToken) {
    return {
      error: "facebook token || facebookId || accessToken khong ton tai",
    };
  }
  const reqResult = await axios.get(
    `https://graph.facebook.com/${facebookId}/friends?access_token=${accessToken}`
  );
  const friendList = await filterFriendList(reqResult.data.data);
  friendList.push(user);
  const friendScores = [];
  for (let i = 0; i < friendList.length; i++) {
    if (friendList[i].isSharedData) {
      const friendId = friendList[i]._id;
      const friendPoint = await lessonUserScoreService.countUserPoint(friendId);
      const friendScore = JSON.parse(JSON.stringify(friendList[i]));
      
      // get list image
      const reqResult = await axios.get(
        friendScore.photoUrl
      );
      const user_image_url = JSON.parse(JSON.stringify(reqResult.data.data));

      friendScore.photoUrl = user_image_url.url;

      friendScore.point = friendPoint;
      friendScores.push(friendScore);
    }
  }
  friendScores.sort(compareScore);
  
  return friendScores;
};

// Get all facebookTokens
const getAllFacebookTokens = async () => {
  const filter = {
    isDeleted: false,
  };

  return await FacebookToken.find(filter);
};

// Get facebookToken by facebookToken id
const getFacebookTokenById = async (facebookTokenId) => {
  const filter = {
    _id: mongoose.Types.ObjectId(facebookTokenId),
    isDeleted: false,
  };
  return await FacebookToken.findOne(filter);
};

// search facebookToken
const searchFacebookToken = async (queryObj) => {
  return await FacebookToken.find(queryObj);
};

// Add new facebookToken
const addFacebookToken = async (data) => {
  const { accessToken, userId } = data;
  assert.notEqual(accessToken, undefined);
  assert.notEqual(userId, undefined);
  const user = await User.findOne({ _id: userId });
  if (!user) {
    return {
      error: "User khong ton tai",
    };
  }
  const newFacebookToken = new FacebookToken(data);
  return await newFacebookToken.save();
};

// Update facebookToken
const updateFacebookToken = async (facebookTokenId, data) => {
  const filter = {
    _id: mongoose.Types.ObjectId(facebookTokenId),
    isDeleted: false,
  };
  const options = {
    new: true,
    upsert: false,
  };
  return await FacebookToken.findOneAndUpdate(filter, data, options);
};

// Delete all facebookTokens
const deleteAllFacebookTokens = async () => {
  return await FacebookToken.deleteMany({});
};

// Delete facebookToken by id
const deleteFacebookTokenById = async (facebookTokenId) => {
  // const filter = {
  //     _id: mongoose.Types.ObjectId(facebookTokenId)
  // }
  // return await FacebookToken.deleteOne(filter)

  return await updateFacebookToken(facebookTokenId, {
    isDeleted: true,
  });
};

module.exports = {
  getFriendListByUserId,
  getFriendScoreByUserId,
  getAllFacebookTokens,
  getFacebookTokenById,
  searchFacebookToken,
  addFacebookToken,
  updateFacebookToken,
  deleteAllFacebookTokens,
  deleteFacebookTokenById,
};
