const express = require("express");
const router = express.Router();
const wordService = require("./wordService");
const { ROUTES, VERSION } = require("../routes/constant");
const handleError = require("../shares/handleError");

router.get(
  `/${VERSION}${ROUTES.WORD.GET_ALL_WORD}`,
  handleError(async (req, res) => {
    const { statusCode, result } = await wordService.getAllWord();
    res.statusCode = statusCode;
    res.send(result);
  })
);

module.exports = router;
