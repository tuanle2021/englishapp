const mongoose = require('mongoose');

class Database {
  constructor() {
    this._connect();
  }

  _connect() {
    const mongoDbURL = process.env.DB_SERVER_URL + process.env.DB_NAME + process.env.DB_OPTIONS;
    // const mongoDbURL = process.env.DB_SERVER_URL + process.env.DB_NAME_TEST + process.env.DB_OPTIONS;
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true
    };

    mongoose.connect(mongoDbURL, options)
      .then(() => {
        console.log('Connected to database');
      })
      .catch((error) => {
        console.log(`Failed to connect to database - error: ${error}`);
      });
  }
}

// singleton
module.exports = new Database();
