const mongoose = require('mongoose');
const { create, read, update, del } = require('./wordDAL');
const Word = require('./wordModel');

// create
const addWord = async (data) => {
  const {
    word_id,
    word,
    lexicalCategory,
    type,
    ori_lang,
    tra_lang,
    definitions,
    shortDefinitions,
    examples,
    phoneticNotation,
    phoneticSpelling,
    audioFile,
    synonyms,
    phrases,
    mean,
    category,
    level,
    image
  } = data;
  // TODO: need assert here?
  const newWord = new Word({
    word_id,
    word,
    lexicalCategory,
    type,
    ori_lang,
    tra_lang,
    definitions,
    shortDefinitions,
    examples,
    phoneticNotation,
    phoneticSpelling,
    audioFile,
    synonyms,
    phrases,
    mean,
    category,
    level,
    image
  });

  return await create(newWord);
};

// read
const getAllWords = async () => {
  return await read();
};
const getWordById = async (wordId) => {
  const options = {
    _id: mongoose.Types.ObjectId(wordId)
  };

  return await read(options);
};

// update
const updateWordField = async (wordId, newData) => {
  const options = {
    wordId: mongoose.Types.ObjectId(wordId),
    newData
  };

  return await update(options);
};

// delete
const deleteAllWords = async () => {
  return await del();
};

const deleteWordById = async (wordId) => {
  // const options = {
  //   _id: mongoose.Types.ObjectId(wordId)
  // };
  //
  // return await del(options);
  return updateWordField(wordId, {
    isDeleted: true
  })
};

module.exports = {
  addWord,
  getAllWords,
  getWordById,
  updateWordField,
  deleteAllWords,
  deleteWordById
};
