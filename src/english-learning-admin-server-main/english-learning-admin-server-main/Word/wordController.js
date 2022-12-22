const wordService = require('./wordService');

const getAllWords = async () => {
  return await wordService.getAllWords();
};

const getWord = async ({ id }) => {
  return await wordService.getWordById(id);
};

const addWord = async (data) => {
  return await wordService.addWord(data);
};

const updateWordField = async (wordId, newData) => {
  return await wordService.updateWordField(wordId, newData);
};

const deleteAllWords = async () => {
  return await wordService.deleteAllWords();
};

const deleteWordById = async ({ id }) => {
  return await wordService.deleteWordById(id);
};

module.exports = {
  getAllWords,
  getWord,
  addWord,
  updateWordField,
  deleteAllWords,
  deleteWordById
};
