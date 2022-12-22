const handleError = function (fn) {
  return async function(req, res, next) {
    try {
      await fn(req, res, next);
    } catch (error) {
      console.log(`Error details - ${error.code}: ${error.message}`);
      next(error);
    }
  };
};

module.exports = handleError;
