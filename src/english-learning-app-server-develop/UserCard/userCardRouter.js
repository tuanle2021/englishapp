const express = require('express');
const router = express.Router();

const { ROUTES } = require('../routes/constant');
const userCardController = require('./userCardController');
const errorWrapper = require('../shares/handleError');

/**
 * get all flashcards
 */
router.get(ROUTES.USER_CARD.GET_ALL, errorWrapper(async (req, res, next) => {
  const data = await userCardController.getAll();
  res.send(data);
}));

/**
 * flexible search using query string:
 *
 * e.g: localhost:3000/?search_field=userid&search_value=123456
 * {search_field}: field name to search
 * {search_value}: field name's value
 *
 * Usage: get all flashcard by user, deck, etc.
 */


/**
 * get flashcards by id - ObjectId
 * {search_field}: _id || userId || wordId
 */
router.get(ROUTES.USER_CARD.GET_BY_ID, errorWrapper(async (req, res, next) => {
  const data = await userCardController.getCardsById(req.query);
  res.send(data);
}));

/**
 * get flashcards by value
 * {search_field}
 */
router.get(ROUTES.USER_CARD.GET_BY_VALUE, errorWrapper(async (req, res, next) => {
  const data = await userCardController.getCardsByValue(req.query);
  res.send(data);
}));

/**
 * create a user flashcard
 * {wordId}
 * {userId}
 */
router.post(ROUTES.USER_CARD.CREATE_ONE, errorWrapper(async (req, res, next) => {
  const result = await userCardController.createOne(req.body);
  res.send(result);
}));

/**
 * a user review flashcard outcome
 * {cardId}
 * {rating}: 0 (again) || 1 (hard) || 2 (good) || 3 (easy)
 */
router.post(ROUTES.USER_CARD.REVIEW_OUTCOME, errorWrapper(async (req, res, next) => {
  const result = await userCardController.userReview(req.body);
  res.send(result);
}));

/**
 * get due & ready-to-learn flashcard by user
 * {userId}
 */
router.get(ROUTES.USER_CARD.GET_DUE, errorWrapper(async (req, res, next) => {
  const data = await userCardController.getUserDueCards(req.params)
  res.send(data);
}));


/**
 * update modifier
 */

module.exports = router;
