const express = require('express');
const router = express.Router({ mergeParams: true });

const quizTypeController = require('./quizTypeController');
const { ROUTES } = require('../../routes/constant');
const { isQuizTypeValid } = require('../../shares/stringUtils');
const wrap = require('../../shares/handleError');
const authService = require('../../Auth/authService');

// authenticate
router.all('*', authService.checkToken);

// default get
router.get(ROUTES.DEFAULT,(req, res) => {
  res.send('quiz types');
});

// get all quiz types
router.get(ROUTES.QUIZ.TYPE.GET_ALL, wrap(async (req, res) => {
  const data = await quizTypeController.getAllQuizTypes();
  res.send(data);
}));

// get quiz type by id
router.get(ROUTES.QUIZ.TYPE.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  const data = await quizTypeController.getQuizType({ id });
  res.send(data);
}));

// create a quiz type
router.post(ROUTES.QUIZ.TYPE.CREATE_ONE, wrap(async (req, res) => {
  const { name } = req.body;
  let result = [];

  if (isQuizTypeValid(name)) {
    result = await quizTypeController.addQuizType(req.body);
  }
  else {
    throw new Error('Invalid quiz type name');
  }

  res.send(result);
}));

// update a quiz type
// router.post(ROUTES.QUIZ.TYPE.UPDATE_BY_ID, wrap(async (req, res) => {
//   // const { id } = req.params;
//   // const updateData = req.body;
//   // const result = await quizTypeController.updateQuizType(id, updateData);
//   // res.send(result);
//   res.send('forbidden');
// }));

// delete all quiz types
// router.get(ROUTES.QUIZ.TYPE.DELETE_ALL, wrap(async (req, res) => {
//   const result = await quizTypeController.deleteAllQuizTypes();
//   res.send(result);
// }));
//
// // delete a quiz type by id
// router.get(ROUTES.QUIZ.TYPE.DELETE_BY_ID,wrap(async (req, res) => {
//   const { id } = req.params;
//   const result = await quizTypeController.deleteQuizTypeById({ id });
//   res.send(result);
// }));

module.exports = router;
