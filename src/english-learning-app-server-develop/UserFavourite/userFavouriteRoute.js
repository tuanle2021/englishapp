const express = require("express");
const router = express.Router();
const isNil = require("lodash/fp/isNull");

const userFavouriteController = require("./userFavouriteController");
const { VERSION, ROUTES } = require("../routes/constant");
const wrap = require("../shares/handleError");

const { verifyUser } = require("../authenticate/authenticate");
const userFavouriteModel = require("./userFavouriteModel");
const { default: mongoose } = require("mongoose");

// authenticate
router.all("*", verifyUser);

// get all
// router.get(`/${VERSION}${ROUTES.USER_FAVOURITE.GET_ALL}`, wrap(async (req, res) => {
//   const result = await userFavouriteController.getAllUserFavourite();
//   res.send(result);
// }));

// search user-favourite
router.get(
  `/${VERSION}${ROUTES.USER_FAVOURITE.GET_BY_FIELD_ID}`,
  wrap(async (req, res) => {
    const { search_field, search_value } = req.query;
    const queryObj = {};

    if (!isNil(search_field) && !isNil(search_value)) {
      queryObj[search_field] = search_value;
    }
    queryObj.isDeleted = false;

    const result = await userFavouriteController.searchUserFavourite(queryObj);
    res.send(result);
  })
);

// get user-favourite by id
router.get(
  `/${VERSION}${ROUTES.USER_FAVOURITE.GET_BY_ID}`,
  wrap(async (req, res) => {
    const { id } = req.params;
    const result = await userFavouriteController.getUserFavouriteById(id);
    res.send(result);
  })
);

router.get(`/${VERSION}${ROUTES.USER_FAVOURITE.GET_BY_USER_ID}`,
wrap(async (req, res) => {
  const { id } = req.params;
  const result = await userFavouriteController.getUserFavouriteByUserId(id);
  res.send({userFavourite: result});
})
);

// Add user-favourite
router.post(
  `/${VERSION}${ROUTES.USER_FAVOURITE.CREATE_ONE}`,
  wrap(async (req, res) => {
    const result = await userFavouriteController.addUserFavourite(req.body);
    res.send({userFavourite: result});
  })
);

// Update user-favourite
router.post(
  `/${VERSION}${ROUTES.USER_FAVOURITE.UPDATE_BY_ID}`,
  wrap(async (req, res) => {
    const { id } = req.params;
    const updateData = req.body;

    const result = await userFavouriteController.updateUserFavourite(
      id,
      updateData
    );
    res.send(result);
  })
);

router.post(`/${VERSION}${ROUTES.USER_FAVOURITE.DELETE_BY_USER}`,wrap(async(req,res)=> {
  const {userId,wordId} = req.body;
  await userFavouriteModel.deleteOne({userId: mongoose.Types.ObjectId(userId),wordId: mongoose.Types.ObjectId(wordId)})
  res.send({success: true});
}))

// Delete all user-favourite
router.get(
  `/${VERSION}${ROUTES.USER_FAVOURITE.DELETE_ALL}`,
  wrap(async (req, res) => {
    const result = await userFavouriteController.deleteAllUserFavourite();
    res.send(result);
  })
);

// Delete user-favourite by id
router.get(
  `/${VERSION}${ROUTES.USER_FAVOURITE.DELETE_BY_ID}`,
  wrap(async (req, res) => {
    const { id } = req.params;
    const result = await userFavouriteController.deleteUserFavouriteById(id);
    res.send(result);
  })
);

module.exports = router;
