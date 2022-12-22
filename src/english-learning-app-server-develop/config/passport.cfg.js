const GoogleTokenStrategy = require("passport-google-token").Strategy;
const FacebookTokenStrategy = require("passport-facebook-token");
const User = require("../User/userModel");
const LocalStrategy = require("passport-local");
const bcrypt = require("bcrypt");
const { createUserData } = require("../services/synchronizeService");
const facebookTokenModel = require("../User/facebookTokenModel");
const { default: mongoose } = require("mongoose");
module.exports = function (passport) {
  passport.use(
    new FacebookTokenStrategy(
      {
        clientID: process.env.FACEBOOK_CLIENT_ID,
        clientSecret: process.env.FACEBOOK_CLIENT_SECRET,
        fbGraphVersion: "v3.0",
      },
      async (accessToken, refreshToken, profile, done) => {
        console.log(accessToken, "-", refreshToken, "-", profile);
        const email = profile.emails[0].value || "";
        // Check if user already exists
        const currentUser = await User.findOne({
          $or: [{ facebookId: profile.id }],
        });
        if (currentUser) {
          await facebookTokenModel.deleteMany({ userId: currentUser._id });
          if (!currentUser.isActive) {
            return done(null, false);
          } else if (currentUser.isLock) {
            return done(null, false);
          }
          if (!currentUser.authStrategy.includes("Facebook")) {
            currentUser.authStrategy = currentUser.authStrategy + ",Facebook";
            await currentUser.save();
          }
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
          // User already exists
          return done(null, currentUser);
        } else {
          if (email != "") {
            const currentUser = await User.findOne({ email: email });
            if (currentUser) {
              if (!currentUser.isActive) {
                return done(null, false);
              } else if (currentUser.isLock) {
                return done(null, false);
              }
              if (!currentUser.authStrategy.includes("Facebook")) {
                currentUser.authStrategy =
                  currentUser.authStrategy + ",Facebook";
                currentUser.facebookId = profile.id;
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
                return done(null, currentUser);
              }
            }
          }

          // register new user

          const newUser = await new User({
            email: email,
            facebookId: profile.id,
            photoUrl: `https://graph.facebook.com/me/picture?access_token=${accessToken}&&redirect=false`,
            username: profile.photos[0].value || "",
            isActive: true,
            mainAuthStrategy: "Facebook",
            authStrategy: "Facebook",
            firstName: profile.name.familyName,
            lastName: profile.name.middleName + " " + profile.name.givenName,
            isActivated: true,
          }).save();
          const facebookToken = await facebookTokenModel.findOne({
            userId: mongoose.Types.ObjectId(newUser._id),
          });
          if (!facebookToken) {
            const newFacebookToken = await new facebookTokenModel({
              userId: newUser._id,
              accessToken: accessToken,
              refreshToken: refreshToken,
            });
            await newFacebookToken.save();
          } else {
            facebookToken.accessToken = accessToken;
            facebookToken.refreshToken = refreshToken;
            await facebookToken.save();
          }
          await createUserData(newUser);
          return done(null, newUser);
        }
      }
    )
  );
  passport.use(
    new GoogleTokenStrategy(
      {
        clientID: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      },
      async (accessToken, refreshToken, profile, done) => {
        const email = profile.emails[0].value;
        const currentUser = await User.findOne({
          $or: [{ googleId: profile.id }],
        });
        if (currentUser) {
          if (!currentUser.isActive) {
            return done(null, false);
          } else if (currentUser.isLock) {
            return done(null, false);
          } else if (!currentUser.authStrategy.includes("Google")) {
            return done(null, false);
          }
          // User already exists
          if (!currentUser.authStrategy.includes("Google")) {
            currentUser.authStrategy = currentUser.authStrategy + ",Google";
            await currentUser.save();
          }
          return done(null, currentUser);
        } else {
          if (email != "") {
            const currentUser = await User.findOne({ email: email });
            if (currentUser) {
              if (!currentUser.isActive) {
                return done(null, false);
              } else if (currentUser.isLock) {
                return done(null, false);
              }
              if (!currentUser.authStrategy.includes("Google")) {
                currentUser.authStrategy = currentUser.authStrategy + ",Google";
                currentUser.googleId = profile.id;
                await currentUser.save();
                return done(null, currentUser);
              }
            }
          }
          // register new user
          const newUser = await new User({
            username: profile.id,
            email: email,
            googleId: profile.id,
            isActive: true,
            authStrategy: "Google",
            mainAuthStrategy: "Google",
            firstName: profile.name.givenName,
            lastName: profile.name.familyName,
            isActivated: true,
            photoUrl: profile._json.picture || "",
          }).save();
          await createUserData(newUser);
          return done(null, newUser);
        }
      }
    )
  );
};
