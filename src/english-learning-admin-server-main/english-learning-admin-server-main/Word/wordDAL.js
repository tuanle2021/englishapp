const wordModel = require('./wordModel');

const create = async (model) => {
  return await model.save();
};

const read = async (options = {}) => {
  options.isDeleted = false;

  return await wordModel.find(options);
};

const update = async (options = {}) => {
  const { wordId, newData } = options;
  const filter = {
    '_id': wordId,
    isDeleted: false
  };
  const update = {
    '$set': newData
  };
  const opt = {
    new: true, // return updated doc
    upsert: false, // not create new doc
    runValidators: true // validate before update
  };

  return await wordModel.findOneAndUpdate(filter, update, opt);
};

const del = async (options = {}) => {
  return await wordModel.deleteMany(options);
};

module.exports = {
  create,
  read,
  update,
  del
};
