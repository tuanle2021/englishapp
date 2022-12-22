const catModel = require('./categoryModel');

const create = async (model) => {
  return await model.save();
};

const read = async (options = {}) => {
  options.isDeleted = false;

  return await catModel.find(options);
};

const update = async (options = {}) => {
  const { catId, newData } = options;
  const filter = {
    '_id': catId,
    'isDeleted': false
  };
  const update = {
    '$set': newData
  };
  const opt = {
    new: true, // return updated doc
    upsert: false, // not create new doc
    runValidators: true // validate before update
  };

  return await catModel.findOneAndUpdate(filter, update, opt);
};

const del = async (options = {}) => {
  return await catModel.findOneAndUpdate(options);
};

module.exports = {
  create,
  read,
  update,
  del
};
