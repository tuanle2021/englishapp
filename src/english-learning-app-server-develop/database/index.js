const mongoose = require('mongoose');

class Database {
  constructor() {
    this._connect();
  }

  _connect() {
    const DBConnectionString =
      process.env.MONGO_DB_SERVER_URL_2 +
      process.env.MONGO_DB_NAME_2 +
      process.env.MONGO_DB_OPTIONS;
    const options = {
      useNewUrlParser: false,
      useUnifiedTopology: true
    };

    mongoose.connect(DBConnectionString, options)
      .then(() => {
        console.log(`Connected to database - connection string: ${DBConnectionString}`);
      })
      .catch((error) => {
        console.log(`Failed to connect to database - error: ${error}`);
      });
  }
}

// singleton
const database = new Database();
module.exports = database;
