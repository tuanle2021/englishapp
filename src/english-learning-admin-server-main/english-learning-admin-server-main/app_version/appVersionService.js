const mongoose = require('mongoose');
const appVersion = require('./appVersionModel');
const assert = require('assert');



// Get by id
const getappVersion = async () => {
  const filter = {
    isDeleted: false
  };
  return await appVersion.findOne(filter);
};


const addappVersion = async (data) => {

  const newappVersion = new appVersion(data);
  return await newappVersion.save();
};

// Update
const updateappVersion = async ( data) => {
  const filter = {
    isDeleted: false
  };
  const options = {
    new: true,
    upsert: false
  };
  return await appVersion.findOneAndUpdate(filter, data, options);
};


module.exports = {
  getappVersion,
  addappVersion,
  updateappVersion,
};
