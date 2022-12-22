const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const cors = require('cors');
const { ROUTES } = require('./routes/constant');
require('./database');
const indexRouter = require('./routes/indexRoute');
const wordRouter = require('./Word/wordRoute');
const categoryRouter = require('./Category/categoryRoute');
const userRouter = require('./User/userRoute');
const subCategoryRouter = require('./SubCategory/subCategoryRoute');
const lessonRouter = require('./Lesson/LessonRoute');
const authRouter = require('./Auth/authRoute');
const quizRouter = require('./Quiz/quizRoute');
const quizTransArrangeRouter = require('./QuizTransArrange/quizTransArrangeRoute');
const quizRightWordRouter = require('./QuizRightWord/quizRightWordRoute');
const quizRightProRouter = require('./QuizRightPro/quizRightProRoute');
const quizFillWordRouter = require('./QuizFillWord/quizFillWordRoute');
const quizFillCharRouter = require('./QuizFillChar/quizFillCharRoute');
const appVersionRouter = require('./app_version/appVersionRoute');

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');
// CORS
const whitelist = process.env.WHITELISTED_DOMAINS
  ? process.env.WHITELISTED_DOMAINS.split(',')
  : [];
const corsOptions = {
  origin: (origin, callback) => {
    // allow requests with no origin (like mobile apps or curl requests)
    if (!origin) { return callback(null, true); }

    if (whitelist.indexOf(origin) === -1) {
      const msg = 'The CORS policy for this site does not allow access from the specified Origin.';
      return callback(new Error(msg), false);
    }

    return callback(null, true);
  },
  credentials: true
};
app.use(cors(corsOptions));

// default settings
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// routing
app.use(ROUTES.DEFAULT, indexRouter);
app.use(ROUTES.WORD.ROOT, wordRouter);
app.use(ROUTES.CATEGORY.ROOT, categoryRouter);
app.use(ROUTES.USER.ROOT, userRouter);
app.use(ROUTES.SUB_CATEGORY.ROOT, subCategoryRouter);
app.use(ROUTES.LESSON.ROOT, lessonRouter);
app.use(ROUTES.AUTH.ROOT, authRouter);
app.use(ROUTES.QUIZ.ROOT, quizRouter);
app.use(ROUTES.QUIZ_TRANS_ARRANGE.ROOT, quizTransArrangeRouter);
app.use(ROUTES.QUIZ_RIGHT_WORD.ROOT, quizRightWordRouter);
app.use(ROUTES.QUIZ_RIGHT_PRONOUNCE.ROOT, quizRightProRouter);
app.use(ROUTES.QUIZ_FILL_WORD.ROOT, quizFillWordRouter);
app.use(ROUTES.QUIZ_FILL_CHAR.ROOT, quizFillCharRouter);
app.use(ROUTES.APPVERSION.ROOT, appVersionRouter);


app.use((req, res, next) => {
  const err = new Error('Đi lộn route rồi bro');
  err.status = 404;
  next(err);
});

// error handler
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  res.status(err.status || 500).send(err.message);
});

module.exports = app;
