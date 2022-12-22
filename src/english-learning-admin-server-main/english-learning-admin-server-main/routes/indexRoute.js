const express = require('express');
const router = express.Router();
const { ROUTES, DOCS } = require('../routes/constant');

const title = 'My Languages - Admin Web App';
const webUrl = `${process.env.SERVER_URL}:${process.env.PORT}`;
const wordUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.WORD}`;
const catUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.CATEGORY}`;
// const levelUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.LEVEL}`;
const sentenceUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.SENTENCE}`;
const quizTypeUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.QUIZ_TYPE}`;
const quizUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.QUIZ}`;
const userUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.USER}`;
const lessonUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.LESSON}`;
const subCategoryUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.SUB_CATEGORY}`;
const authUrl = `${process.env.SERVER_URL}:${process.env.PORT}${DOCS.AUTH}`;

router.get(ROUTES.DEFAULT, (req, res) => {
  res.render('index', {
    title,
    webUrl,
    authUrl,
    wordUrl,
    catUrl,
    // levelUrl,
    sentenceUrl,
    quizTypeUrl,
    quizUrl,
    userUrl,
    lessonUrl,
    subCategoryUrl
  });
});

router.get(DOCS.WORD, (req, res) => {
  res.render('word', { title, webUrl });
});

router.get(DOCS.CATEGORY, (req, res) => {
  res.render('category', { title, webUrl });
});

// router.get(DOCS.LEVEL, (req, res) => {
//   res.render('level', { title, webUrl });
// });

router.get(DOCS.SENTENCE, (req, res) => {
  res.render('sentence', { title, webUrl });
});

router.get(DOCS.QUIZ_TYPE, (req, res) => {
  res.render('quiztype', { title, webUrl });
});

router.get(DOCS.QUIZ, (req, res) => {
  res.render('quiz', { title, webUrl });
});

router.get(DOCS.LESSON, (req, res) => {
  res.render('lesson', { title, webUrl });
});

router.get(DOCS.AUTH, (req, res) => {
  res.render('auth', { title, webUrl });
});

module.exports = router;
