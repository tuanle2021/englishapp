const handleError = function (fn) {
  return async function (req, res, next) {
    try {
      await fn(req, res, next);
    } catch (error) {
      console.log(`[ERROR] - CODE: ${error.code}`);
      console.log(`[ERROR] - MESSAGE: ${error.message}`);
      next(error);
    }
  };
};

module.exports = handleError;
