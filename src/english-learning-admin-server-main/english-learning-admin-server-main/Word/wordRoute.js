const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ dest: 'public/tmp/' });
const fs = require('fs');

const wordController = require('./wordController');
const { ROUTES } = require('../routes/constant');
const authService = require('../Auth/authService');
const wrap = require('../shares/handleError');
const isNil = require('lodash/fp/isNull');
const wordModel = require('./wordModel');

// authenticate
router.all('*', authService.checkToken);

// router.post('/uploadfile', upload.single('wordImage'), (req, res) => {
//   const file = req.file;
//   if (!file) {
//     const error = new Error('Please upload a file');
//     res.send(error);
//   } else {
//     const img = fs.readFileSync(req.file.path);
//     const encode_image = img.toString('base64');
//     console.log(encode_image);
//     res.send(encode_image);
//   }
// });

// default get
router.get(ROUTES.DEFAULT, (req, res) => {
  res.send('word');
});

// get all words
router.get(ROUTES.WORD.GET_ALL, wrap(async (req, res) => {
  const data = await wordController.getAllWords();
  res.send(data);
}));

// Search word
router.get(ROUTES.WORD.GET_BY_FIELD_ID, wrap(async (req, res) => {
  const { search_field, search_value } = req.query;
  const queryObj = {};

  if (!isNil(search_field) && !isNil(search_value)) {
    queryObj[search_field] = search_value;
  }
  queryObj.isDeleted = false;

  const result = await wordController.getAllWords(queryObj);
  res.send(result);
}));

// get word by id
router.get(ROUTES.WORD.GET_BY_ID, wrap(async (req, res) => {
  const { id } = req.params;
  let data = await wordController.getWord({ id });
  const word_id = data[0]._id.toString();

  // // getimage

  try{
    path = `public/wordImages/${word_id}.jpg`;

    const img = fs.readFileSync(path);
    
    data[0].image = img.toString('base64');
  }catch(e){

  }
  res.send(data);
}));

// create a word
router.post(ROUTES.WORD.CREATE_ONE, upload.single('wordImage'), wrap(async (req, res) => {
  const file = req.file;
  const {word_id} = req.body;
  
  const result = await wordController.addWord(req.body);
  if (file) {
    const img = fs.readFileSync(req.file.path);
    const path = `public/wordImages/${result._id}.jpg`;
    fs.writeFileSync(path, img);
    const encode_image = img.toString('base64');
    req.body.image = `wordImages/${result._id}.jpg`;
  }
  res.send(result);
}));

// update a word field by id
router.post(ROUTES.WORD.UPDATE_BY_ID, upload.single('wordImage'), wrap(async (req, res) => {
  const { id } = req.params;
  const word = await wordModel.findOne({_id: id});
  const word_id = word._id;
  const file = req.file;
  let path;

  if (file) {
    const img = fs.readFileSync(req.file.path);
    console.log("path",req.file.path);

    path = `public/wordImages/${word_id}.jpg`;
    fs.writeFileSync(path, img);
    const encode_image = img.toString('base64');
    req.body.image = `wordImages/${word_id}.jpg`;
  }else{
    req.body.image = word.image;
  }

  const result = await wordController.updateWordField(id, req.body);
  res.send(result);
}));

// delete all words
router.get(ROUTES.WORD.DELETE_ALL, wrap( async (req, res) => {
  const result = await wordController.deleteAllWords();
  res.send(result);
}));

// delete word by id
router.get(ROUTES.WORD.DELETE_BY_ID, wrap( async (req, res) => {
  const { id } = req.params;
  const result = await wordController.deleteWordById({ id });
  res.send(result);
}));

module.exports = router;
