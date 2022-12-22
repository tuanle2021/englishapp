const GoogleTokenStrategy = require("passport-google-token").Strategy;
const FacebookTokenStrategy = require("passport-facebook-token");
const User = require("../User/userModel");
const LocalStrategy = require("passport-local");
const bcrypt = require("bcrypt");
const {createUserData} = require('../services/synchronizeService');
const { default: mongoose } = require("mongoose");
const facebookTokenModel = require("../User/facebookTokenModel");
module.exports = function(passport) {
    passport.use("linkingFacebook",
        new FacebookTokenStrategy({
                clientID: process.env.FACEBOOK_CLIENT_ID,
                clientSecret: process.env.FACEBOOK_CLIENT_SECRET,
                fbGraphVersion: "v3.0",
                passReqToCallback: true
            },
            async(req,accessToken, refreshToken, profile, done) => {
                const currentUser = await User.findOne({_id: mongoose.Types.ObjectId(req.body.id)});

                const userWithFacebook = await User.findOne({facebookId: profile.id}) 
                console.log(req.body)

                if (userWithFacebook == null || userWithFacebook == undefined) {
                    if (currentUser) {
                        req.body.isHasOtherUser = false
                        if (currentUser.facebookId == "" || currentUser.facebookId == null || currentUser.facebookId == undefined) {
                            currentUser.facebookId = profile.id;
                            currentUser.authStrategy = currentUser.authStrategy + ',Facebook'
                            await currentUser.save();
                            const facebookToken = await facebookTokenModel.findOne({
                                userId: mongoose.Types.ObjectId(currentUser._id),
                              });
                              if (!facebookToken) {
                                const newFacebookToken = await new facebookTokenModel({
                                  userId: currentUser._id,
                                  accessToken: accessToken,
                                  refreshToken: refreshToken,
                                });
                                await newFacebookToken.save();
                              } else {
                                facebookToken.accessToken = accessToken;
                                facebookToken.refreshToken = refreshToken;
                                await facebookToken.save();
                              }
                            return done(null,currentUser)
                        }
                        else {
                            const facebookToken = await facebookTokenModel.findOne({
                                userId: mongoose.Types.ObjectId(currentUser._id),
                              });
                              if (!facebookToken) {
                                const newFacebookToken = await new facebookTokenModel({
                                  userId: currentUser._id,
                                  accessToken: accessToken,
                                  refreshToken: refreshToken,
                                });
                                await newFacebookToken.save();
                              } else {
                                facebookToken.accessToken = accessToken;
                                facebookToken.refreshToken = refreshToken;
                                await facebookToken.save();
                              }
                            return done(null,currentUser)
                        }
                       
                    }
                }
                else {
                    if (currentUser._id == userWithFacebook._id) {
                        return done(null,currentUser)
                    }
                    req.body.isHasOtherUser  = true
                    return done(null,currentUser)
                }
                
               
            }
        )
    );
    passport.use("linkingGoogle",
        new GoogleTokenStrategy({
                clientID: process.env.GOOGLE_CLIENT_ID,
                clientSecret: process.env.GOOGLE_CLIENT_SECRET,
                passReqToCallback: true
            },
            async(req,accessToken, refreshToken, profile, done) => {

                const currentUser = await User.findOne({_id: mongoose.Types.ObjectId(req.body.id)});

                const userWithGoogle = await User.findOne({googleId: profile.id})
                if (userWithGoogle == null || userWithGoogle == undefined) {
                    req.body.isHasOtherUser = false
                    if (currentUser) {
                        if (currentUser.googleId == "" || currentUser.googleId == undefined || currentUser.googleId == null) {
                            currentUser.googleId = profile.id;
                        currentUser.authStrategy = currentUser.authStrategy + ',Google'
                        await currentUser.save();
                        return done(null,currentUser)
                        }
    
                        else {
                            return done(null,currentUser)
                        }
                        
                    }
                }
                else {
                    if (currentUser._id == userWithGoogle._id) {
                        return done(null,currentUser)
                    }
                    req.body.isHasOtherUser = true
                    return done(null,currentUser)
                }


               
            }
        )
    );
};