const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Root");
});

router.get("/tmp/:text", (req, res) => {
  const { text } = req.params;
  res.render("tmp", { text: text });
});

module.exports = router;
