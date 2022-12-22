const timestamp = function (schema) {
  schema.add({
    created_at: Date,
    updated_at: Date
  });

  // pre hook
  // not using arrow function here
  schema.pre('save', function (next) {
    const now = Date.now();

    this.updated_at = now;

    if (!this.created_at) {
      this.created_at = now;
    }

    next();
  });

  schema.pre('findOneAndUpdate', function (next) {
    this._update.updated_at = Date.now();

    next();
  });
};

module.exports = timestamp;
