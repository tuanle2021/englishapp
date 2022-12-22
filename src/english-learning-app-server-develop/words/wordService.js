const Word = require("./wordModel");

const getAllWord = async () => {
  const listWord = await Word.find();
  if (listWord) {
    var returnList = [];
    listWord.forEach((word) => {
      word["id"] = word["_id"];
      word["_id"] = undefined;
      for (var key in word) {
        if (word[key] == "NaN") {
          word[key] = undefined;
        }
      }
      returnList.push(word);
    });
    return { statusCode: 200, result: returnList };
  } else {
    return { statusCode: 500, result: "Empty word" };
  }
};

module.exports = {
    getAllWord: getAllWord
}
