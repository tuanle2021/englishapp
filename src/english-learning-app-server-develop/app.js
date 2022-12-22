const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const passport = require("passport");
const logger = require("morgan");
const path = require("path");
// const bodyParser = require('body-parser');
require("dotenv").config();
require("./database");
require("./strategies/JwtStrategy.js");
require("./strategies/LocalStrategy.js");
require("./authenticate/authenticate");
require("./config/passport.cfg")(passport);
require("./config/passport.cfglinking")(passport);

const { ROUTES } = require("./routes/constant");
const userRouter = require("./User/userRouter");
const authRouter = require("./auth/authRouter");
const wordRouter = require("./words/wordRouter");
const indexRouter = require("./routes/indexRouter");
const userCardRouter = require("./UserCard/userCardRouter");
const categoryUserRouter = require("./CategoryUser/categoryUserRoute");
const lessonUserRouter = require("./LessonUser/lessonUserRoute");
const lessUserScoreRouter = require("./LessonUserScore/lessonUserRoute");
const userFavouriteRouter = require("./UserFavourite/userFavouriteRoute");
const facebookTokenRouter = require("./User/facebookTokenRouter");

const appVersionRouter = require("./app_version/appVersionRoute");

const feedbackRouter = require('./Feedback/feedbackRoute');


const app = express();

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "hbs");

// default setting
app.use(logger("dev"));
app.use(cookieParser(process.env.COOKIE_SECRET));
// app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "public")));

// add the client URL to the CORS policy
const whitelist = process.env.WHITELISTED_DOMAINS
  ? process.env.WHITELISTED_DOMAINS.split(",")
  : [];
const corsOptions = {
  origin: function (origin, callback) {
    if (!origin || whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },

  credentials: true,
};
// app.use(cors(corsOptions));
app.use(cors());

app.use(passport.initialize());

// routing
app.use(ROUTES.ROOT, indexRouter);
app.use(ROUTES.FACEBOOK_TOKEN.ROOT, facebookTokenRouter);
app.use(ROUTES.AUTH.ROOT, authRouter);
app.use(ROUTES.APP_VERSION.ROOT,appVersionRouter);
app.use(ROUTES.USER.ROOT, userRouter);
app.use(ROUTES.WORD.ROOT, wordRouter);
app.use(ROUTES.WORD.ROOT, wordRouter);
app.use(ROUTES.USER_CARD.ROOT, userCardRouter);
app.use(ROUTES.CATEGORY_USER.ROOT, categoryUserRouter);
app.use(ROUTES.LESSON_USER.ROOT, lessonUserRouter);
app.use(ROUTES.LESSON_USER_SCORE.ROOT, lessUserScoreRouter);
app.use(ROUTES.USER_FAVOURITE.ROOT, userFavouriteRouter);
app.use(ROUTES.FEEDBACK.ROOT, feedbackRouter);

// other routes
app.use((req, res, next) => {
  const err = new Error("Đi lộn route rồi bro");
  err.status = 404;
  next(err);
});

// error handler
app.use((err, req, res, next) => {
  res.status(err.status || 500).send(err.message);
});

module.exports = app;
